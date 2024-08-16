import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/utils/local_notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTestPage extends StatefulWidget {
  @override
  _NotificationTestPageState createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  TimeOfDay? selectedTime;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
    _loadSavedTime();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      await _saveSelectedTime(picked);
    }
  }

  Future<void> _saveSelectedTime(TimeOfDay timeOfDay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ensure minute is always two digits
    final String timeString =
        '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    await prefs.setString('selectedTime', timeString);
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? timeString = prefs.getString('selectedTime');
    if (timeString != null) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: minute);
        print(selectedTime);
      });
    }
  }

  void _scheduleNotification() {
    if (selectedTime != null) {
      DateTime now = DateTime.now();

      // Get the current date and set the selected time
      DateTime scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      // If the scheduled time is before now, schedule for the next day
      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      // Schedule the notification for the selected time
      _notificationService.scheduleNotification(
        id: 0,
        title: 'Reminder: Time to take your medication!',
        body: "This is your daily medication reminder.",
        scheduledNotificationDateTime: scheduledDateTime,
      );

      print("Scheduled for $scheduledDateTime");
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedTime == null
                  ? 'No time selected'
                  : 'Selected time: ${selectedTime!.format(context)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
