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

class PatientsFirestoreService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('Patients');

  Future<void> addPatient(String firstName, String lastName, String phoneNumber, DateTime birthDate, bool hasRhinits, bool hasAsthma, String uid, String otp) async {
    await _patientsCollection.add({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'has_allergic_rhinitis': hasRhinits,
      'has_asthma': hasAsthma,
      'otp':  otp
    });
  }

  Stream<List<Patient>> getPatients() {
    return _patientsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Patient.fromFirestore(doc)).toList());
  }
}

class Patient {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime birthDate;
  final bool hasRhinits;
  final bool hasAsthma;
  final String uid;
  final String otp;

  Patient({required this.firstName, required this.lastName, required this.phoneNumber, required this.birthDate,
   required this.hasRhinits, required this.hasAsthma, required this.uid, required this.otp,});

  factory Patient.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Patient(
      firstName: data['first_name'],
      lastName: data['last_name'],
      phoneNumber: data['phone_number'],
      birthDate: data['birth_date'],
      hasRhinits: data['has_allergic_rhinitis'],
      hasAsthma: data['hasAsthma'],
      uid: data['uid'],
      otp: data['name']
    );
  }
}

