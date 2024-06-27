import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:immunotheraphy_app/patient/utils/notification_handler.dart';

class DatabaseController {
  final String userId;

  DatabaseController(this.userId);

  Future<void> addDosageTime(Map<String, dynamic> dosageDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Dosage Recordings')
          .add(dosageDetails);
      print('Dosage time added to Firestore for user $userId');
    } catch (e) {
      print('Failed to add dosage time to Firestore: $e');
      throw e;
    }
  }

  Future<List<DosageData>> getSortedDosageData() async {
    try {
      // Reference to the dosage collection for the current user
      CollectionReference dosageCollection = FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Dosage Recordings');

      // Retrieve dosage data from Firestore
      QuerySnapshot snapshot =
          await dosageCollection.orderBy("dosage_date").get();

      List<DosageData> dosageData = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return DosageData(
            date: (data['dosage_date'] as Timestamp).toDate(),
            amount: data['dosage_amount'] as double,
            isHospital: data['is_hospital_dosage']);
      }).toList();

      return dosageData;
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      return [];
    }
  }

  Future<bool> isLastDoseToday() async {
    CollectionReference dosageCollection = FirebaseFirestore.instance
        .collection('Patients')
        .doc(userId)
        .collection('Dosage Recordings');
    QuerySnapshot snapshot = await dosageCollection
        .orderBy("dosage_date", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var latestDose = snapshot.docs.first.data() as Map<String, dynamic>;
      Timestamp dosageTimestamp = latestDose['dosage_date'] as Timestamp;
      DateTime dosageDate = dosageTimestamp.toDate();

      // Get today's date
      DateTime today = DateTime.now();

      // Compare dates without time
      DateTime dosageDateWithoutTime =
          DateTime(dosageDate.year, dosageDate.month, dosageDate.day);
      DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);

      if (dosageDateWithoutTime.isAtSameMomentAs(todayWithoutTime)) {
        print("The latest dosage was taken today.");
        return true;
      } else if (dosageDateWithoutTime.isBefore(todayWithoutTime)) {
        print("The latest dosage was taken before today.");
        return false;
      } else {
        print("The latest dosage is recorded for a future date.");
        return false;
      }
    } else {
      print('No dosage records found.');
      return false;
    }
  }

  // Method to add symptoms to the symptoms table
  Future<void> addSymptoms(List<Map<String, dynamic>> symptoms) async {
    try {
      final CollectionReference symptomRecordings = FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Symptom Recordings');

      // Loop through each symptom and add it to Firestore
      for (Map<String, dynamic> symptomDetails in symptoms) {
        await symptomRecordings.add(symptomDetails);
        print('Symptom added to Firestore for user $userId');
        print(symptomDetails);
      }
      final DocumentSnapshot patientRecordings = await FirebaseFirestore
          .instance
          .collection('Patients')
          .doc(userId)
          .get();
      String doctorId = patientRecordings['uid'];
      String patientName = patientRecordings['first_name'] +
          " " +
          patientRecordings['last_name'];

      // ! Change this
      await sendNotificationToDoctor(doctorId, patientName);
    } catch (e) {
      print('Failed to add symptoms to Firestore: $e');
      throw e;
    }
  }

  // ALTAY Token (yerli ve milli): dR_VgAdWy0jvsAICbHOkLt:APA91bGeC4MWNAKncRWz_G3o97G62TvlzkDA0Yd2hiR6mQmlUmvUE16oqDcVcig5xT4eZqpCqtwckWWgtc62unMNqI7aJlOMio4rLDvF4bm20yOy79XfoeW4qxBwKP_cRyMCcA7tSRXa

  // Future<void> sendNotificationToDoctor(
  //     String doctorId, String patientName) async {
  //   // Fetch the doctor's FCM token from Firestore
  //   DocumentSnapshot doc = await FirebaseFirestore.instance
  //       .collection('doctors')
  //       .doc(doctorId)
  //       .get();
  //   // String? fcmToken = doc['fcmToken'];
  //   String? fcmToken =
  //       "dR_VgAdWy0jvsAICbHOkLt:APA91bGeC4MWNAKncRWz_G3o97G62TvlzkDA0Yd2hiR6mQmlUmvUE16oqDcVcig5xT4eZqpCqtwckWWgtc62unMNqI7aJlOMio4rLDvF4bm20yOy79XfoeW4qxBwKP_cRyMCcA7tSRXa";

  //   if (fcmToken != null) {
  //     // Define your server key from Firebase project settings
  //     const String serverKey = 'YOUR_SERVER_KEY';

  //     // Create the notification payload
  //     final Map<String, dynamic> notification = {
  //       'notification': {
  //         'title': 'New Symptom Registered',
  //         'body': 'A new symptom has been registered by $patientName.',
  //       },
  //       'priority': 'high',
  //       'to': fcmToken,
  //     };

  //     // Send the POST request to FCM
  //     final response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$serverKey',
  //       },
  //       body: json.encode(notification),
  //     );

  //     if (response.statusCode == 200) {
  //       print('Notification sent successfully');
  //     } else {
  //       print('Failed to send notification: ${response.statusCode}');
  //     }
  //   }
  // }

  Future<void> processTempPatientRecord(
      String otp, String phoneNumber, String patientId) async {
    try {
      CollectionReference tempPatientsCollection =
          FirebaseFirestore.instance.collection('Temp_Patients');

      QuerySnapshot snapshot = await tempPatientsCollection
          .where('otp', isEqualTo: otp)
          .where('phone_number', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> tempPatientData =
            snapshot.docs.first.data() as Map<String, dynamic>;

        CollectionReference patientsCollection =
            FirebaseFirestore.instance.collection('Patients');

        tempPatientData['patient_id'] =
            patientId; // Replace 'newField' and 'newValue' with your actual field name and value

        await patientsCollection.doc(patientId).set(tempPatientData);

        await snapshot.docs.first.reference.delete();

        print("Record deleted from Temp_patients collection");
      } else {
        print('No matching record found in Temp_patients collection.');
      }
    } catch (e) {
      print('Failed to process temp patient record: $e');
    }
  }
}

class DosageData {
  final DateTime date;
  final double amount;
  final bool isHospital;
  DosageData(
      {required this.date, required this.amount, required this.isHospital});
}
