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
}
