import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/utils/local_notification_handler.dart';

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
    }
  }

  void _scheduleNotification() {
    if (selectedTime != null) {
      DateTime now = DateTime.now();

      // Notification 5 minutes before the scheduled time
      DateTime fiveMinutesBefore = now.add(const Duration(seconds: 10));
      if (fiveMinutesBefore.isAfter(now)) {
        NotificationService().scheduleNotification(
            id: 0,
            title: 'Reminder: 1 minutes to immunotherapy!',
            body: "title",
            scheduledNotificationDateTime: fiveMinutesBefore);
        print("scheduled for $fiveMinutesBefore");
      }
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
