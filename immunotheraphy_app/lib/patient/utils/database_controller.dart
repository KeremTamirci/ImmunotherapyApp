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
      // Reference to the dosage collection for the current user
      CollectionReference dosageCollection = FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Dosage Recordings');

      // Retrieve dosage data from Firestore
      QuerySnapshot snapshot =
          await dosageCollection.orderBy("dosage_date").get();

      // Convert Firestore data to DosageData objects
      List<DosageData> dosageData = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return DosageData(
            date: (data['dosage_date'] as Timestamp).toDate(),
            amount: data['dosage_amount'] as int,
            isHospital: data['is_hospital_dosage']);
      }).toList();

      return dosageData;
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      // Handle error
      return [];
    }
  }

  Future<void> processTempPatientRecord(
      String otp, String phoneNumber, String patientId) async {
    try {
      // Reference to the Temp_patients collection
      CollectionReference tempPatientsCollection =
          FirebaseFirestore.instance.collection('Temp_Patients');

      // Retrieve the record where OTP and phone number match
      QuerySnapshot snapshot = await tempPatientsCollection
          .where('otp', isEqualTo: otp)
          .where('phone_number', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      // If there is a matching record, write it into the Patients collection
      if (snapshot.docs.isNotEmpty) {
        // Get the matching record and cast it to Map<String, dynamic>
        Map<String, dynamic> tempPatientData =
            snapshot.docs.first.data() as Map<String, dynamic>;

        // Reference to the Patients collection
        CollectionReference patientsCollection =
            FirebaseFirestore.instance.collection('Patients');

        // Write the record into the Patients collection with the provided patientId
        await patientsCollection.doc(patientId).set(tempPatientData);

        // Delete the record from the Temp_patients collection
        await snapshot.docs.first.reference.delete();

        print("Record deleted from Temp_patients collection");
      } else {
        // If no matching record found
        print('No matching record found in Temp_patients collection.');
      }
    } catch (e) {
      print('Failed to process temp patient record: $e');
      // Handle error
    }
  }
}

class DosageData {
  final DateTime date;
  final int amount;
  final bool isHospital;
  DosageData(
      {required this.date, required this.amount, required this.isHospital});
}
