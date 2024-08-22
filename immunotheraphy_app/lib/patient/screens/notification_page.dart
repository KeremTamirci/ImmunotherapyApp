import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/utils/local_notification_handler.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  TimeOfDay? selectedTime;
  bool notificationsEnabled = false;
  final NotificationService _notificationService = NotificationService();
  DateTime _selectedTimeCupertino = DateTime.now(); // Default initialization
  bool _showTime = false;

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
    _loadSavedTime();
    _loadNotificationPreference();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    _toggleDatePickerVisibility();
  }

  Future<void> _saveSelectedTime(TimeOfDay timeOfDay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ensure minute is always two digits
    final String timeString =
        '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    await prefs.setString('selectedTime', timeString);
    setState(() {
      selectedTime = timeOfDay;
      _selectedTimeCupertino = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    });
  }

  void _toggleDatePickerVisibility() {
    if (_showTime) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _showTime = !_showTime;
    });
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
        _selectedTimeCupertino = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
      });
    }
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  void _scheduleNotification() {
    if (selectedTime != null && notificationsEnabled) {
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
        title: AppLocalizations.of(context)!.reminder,
        body: AppLocalizations.of(context)!.daily,
        scheduledNotificationDateTime: scheduledDateTime,
      );

      Navigator.pop(context);
    } else if (!notificationsEnabled) {
      _notificationService.disableNotifications(0);
      Navigator.pop(context);
    } else {
      setState(() {
        notificationsEnabled = false;
        _saveNotificationPreference(false);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.reminderSettings),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              dividerMargin: -22.0,
              children: [
                CupertinoListTile(
                  title:
                      Text(AppLocalizations.of(context)!.enableNotifications),
                  trailing: CupertinoSwitch(
                    value: notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        notificationsEnabled = value;
                        _saveNotificationPreference(value);
                      });
                    },
                  ),
                ),
                CupertinoListTile(
                  title: Text(AppLocalizations.of(context)!.reminderTime),
                  trailing: CupertinoButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      selectedTime == null
                          ? AppLocalizations.of(context)!.selectTime
                          : '${selectedTime!.format(context)}',
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    child: _showTime
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  use24hFormat: true,
                                  initialDateTime: _selectedTimeCupertino,
                                  onDateTimeChanged: (DateTime newDateTime) {
                                    setState(() {
                                      _selectedTimeCupertino = newDateTime;
                                      selectedTime = TimeOfDay(
                                        hour: newDateTime.hour,
                                        minute: newDateTime.minute,
                                      );
                                    });
                                    _saveSelectedTime(selectedTime!);
                                  },
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                //bunu uncommentleyip alttakini commentlersek cupertino buttona dönecek
                /*CupertinoButton(
                  onPressed: _scheduleNotification,
                  child: Text(AppLocalizations.of(context)!.savePreferences),
                ),*/
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: MainElevatedButton(
                AppLocalizations.of(context)!.savePreferences,
                onPressed: () {
                  _scheduleNotification();
                },
                widthFactor: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
