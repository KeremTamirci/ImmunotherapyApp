import 'package:cloud_firestore/cloud_firestore.dart';

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
      CollectionReference dosageCollection =
          FirebaseFirestore.instance.collection('Patients').doc(userId).collection('Dosage Recordings');

      QuerySnapshot snapshot = await dosageCollection.orderBy("dosage_date").get();

      List<DosageData> dosageData = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return DosageData(
          date: (data['dosage_date'] as Timestamp).toDate(),
          amount: data['dosage_amount'] as int,
        );
      }).toList();

      return dosageData;
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      return [];
    }
  }

  // Method to add symptoms to the symptoms table
  Future<void> addSymptoms(Map<String, dynamic> symptomDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Symptom Recordings')
          .add(symptomDetails);
      print('Symptoms added to Firestore for user $userId');
      print(symptomDetails);
    } catch (e) {
      print('Failed to add symptoms to Firestore: $e');
      throw e;
    }
  }

  Future<void> processTempPatientRecord(String otp, String phoneNumber, String patientId) async {
    try {
      CollectionReference tempPatientsCollection = FirebaseFirestore.instance.collection('Temp_Patients');

      QuerySnapshot snapshot = await tempPatientsCollection
          .where('otp', isEqualTo: otp)
          .where('phone_number', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> tempPatientData = snapshot.docs.first.data() as Map<String, dynamic>;
        
        CollectionReference patientsCollection = FirebaseFirestore.instance.collection('Patients');

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
  final int amount;

  DosageData({required this.date, required this.amount});
}
