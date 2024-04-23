import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsFirestoreService {
  final CollectionReference _doctorsCollection =
      FirebaseFirestore.instance.collection('Doctors');

  Future<void> addDoctor(String firstName, String lastName, String phoneNumber, String uid) async {
    await _doctorsCollection.add({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber 
    });
  }

  Stream<List<Doctor>> getDoctors() {
    return _doctorsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList());
  }
}

class Doctor {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String uid;

  Doctor({required this.uid, required this.firstName, required this.lastName, required this.phoneNumber});

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Doctor(
      firstName: data['first_name'],
      lastName: data['last_name'],
      phoneNumber: data['phone_number'],
      uid: data['uid']
    );
  }
}
