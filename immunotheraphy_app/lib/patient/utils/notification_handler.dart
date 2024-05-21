import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Replace with your project's service account file
const String serviceAccountKeyPath =
    'immunotheraphy_app/lib/patient/utils/private_key/immunotheraphytracker-firebase-adminsdk-ws0wd-37f9d772d5.json';

// Define the FCM endpoint
const String fcmEndpoint =
    'https://fcm.googleapis.com/v1/projects/immunotheraphytracker/messages:send';

// Function to get the access token
Future<String> getAccessToken() async {
  final serviceAccount = ServiceAccountCredentials.fromJson(
    json.decode(await File(serviceAccountKeyPath).readAsString()),
  );

  final httpClient = http.Client();
  final credentials = await obtainAccessCredentialsViaServiceAccount(
    serviceAccount,
    ['https://www.googleapis.com/auth/cloud-platform'],
    httpClient,
  );

  return credentials.accessToken.data;
}

// Function to send the notification
Future<void> sendNotificationToDoctor(
    String doctorId, String patientName) async {
  // Fetch the doctor's FCM token from Firestore
  // DocumentSnapshot doc = await FirebaseFirestore.instance
  //     .collection('doctors')
  //     .doc(doctorId)
  //     .get();
  // String? fcmToken = doc['fcmToken'];
  String fcmToken =
      "dR_VgAdWy0jvsAICbHOkLt:APA91bGeC4MWNAKncRWz_G3o97G62TvlzkDA0Yd2hiR6mQmlUmvUE16oqDcVcig5xT4eZqpCqtwckWWgtc62unMNqI7aJlOMio4rLDvF4bm20yOy79XfoeW4qxBwKP_cRyMCcA7tSRXa";

  if (fcmToken != null) {
    // Get the access token
    final String accessToken = await getAccessToken();

    // Create the notification payload
    final Map<String, dynamic> notification = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': 'New Symptom Registered',
          'body': 'A new symptom has been registered by $patientName.',
        },
      },
    };

    // Send the POST request to FCM
    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}
