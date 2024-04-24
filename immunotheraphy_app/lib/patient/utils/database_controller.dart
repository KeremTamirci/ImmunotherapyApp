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

   Future<List<DosageData>> getDosageData() async {
    try {
      // Reference to the dosage collection for the current user
      CollectionReference dosageCollection =
          FirebaseFirestore.instance.collection('Patients').doc(userId).collection('Dosage Recordings');

      // Retrieve dosage data from Firestore
      QuerySnapshot snapshot = await dosageCollection.get();

      // Convert Firestore data to DosageData objects
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
      // Handle error
      return [];
    }
  }
}

class DosageData {
  final DateTime date;
  final int amount;

  DosageData({required this.date, required this.amount});
}
