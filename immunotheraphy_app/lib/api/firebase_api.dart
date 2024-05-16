import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    "High Importance Notifications",
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    print("Token: $fCMToken");

    initPushNotifications();
    initLocalNotifications();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<Map<String, dynamic>> getUserType(String userId) async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(userId)
          .get();
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .get();

      final bool isDoctor = doctorSnapshot.exists;
      final bool isPatient = patientSnapshot.exists;

      return {'isDoctor': isDoctor, 'isPatient': isPatient};
    } catch (e) {
      print('Error getting user type: $e');
      return {};
    }
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    return;
  }
}
