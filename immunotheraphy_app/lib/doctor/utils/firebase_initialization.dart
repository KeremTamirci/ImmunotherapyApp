import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsFirestoreService {
  final CollectionReference _doctorsCollection =
      FirebaseFirestore.instance.collection('Doctors');

  Future<void> addDoctor(String firstName, String lastName, String phoneNumber,
      String uid, String appToken, String hospitalToken) async {
    await _doctorsCollection.doc(uid).set({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'app_token': appToken,
      'hospital_token': hospitalToken,
    });
  }

  Stream<List<Doctor>> getDoctors() {
    return _doctorsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList());
  }

  static Future<String> getHospitalToken(String doctorId) async {
    final CollectionReference doctorsCollection =
        FirebaseFirestore.instance.collection('Doctors');

    try {
      // Get the document by ID
      DocumentSnapshot doctorSnapshot =
          await doctorsCollection.doc(doctorId).get();

      if (doctorSnapshot.exists) {
        // Access the hospitalToken field
        var hospitalToken = doctorSnapshot.get('hospital_token');

        // Use the hospitalToken as needed
        return hospitalToken;
      } else {
        print('Doctor with ID $doctorId does not exist.');
        return "0";
      }
    } catch (e) {
      print('Error retrieving hospital token: $e');
      return "0";
    }
  }
}

class Doctor {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String uid;
  final String appToken;
  final String hospitalToken;

  Doctor({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.appToken,
    required this.hospitalToken,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Doctor(
      firstName: data['first_name'],
      lastName: data['last_name'],
      phoneNumber: data['phone_number'],
      uid: data['uid'],
      appToken: data['app_token'],
      hospitalToken: data['hospital_token'],
    );
  }
}

class TempPatientsFirestoreService {
  final CollectionReference _tempPatientsCollection =
      FirebaseFirestore.instance.collection('Temp_Patients');

  Future<void> addPatient(
    String firstName,
    String lastName,
    String phoneNumber,
    DateTime birthDate,
    String gender,
    String allergyType,
    bool hasRhinits,
    bool hasAsthma,
    bool hasAtopicDermatitis,
    String uid,
    String otp,
  ) async {
    String? hospitalToken = await DoctorsFirestoreService.getHospitalToken(uid);
    await _tempPatientsCollection.add({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'gender': gender,
      'allergy_type': allergyType,
      'has_allergic_rhinitis': hasRhinits,
      'has_asthma': hasAsthma,
      'has_atopic_dermatitis': hasAtopicDermatitis,
      'otp': otp,
      'hospital_token': hospitalToken,
    });
  }

  Stream<List<Patient>> getPatients() {
    return _tempPatientsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Patient.fromFirestore(doc)).toList());
  }
}

class PatientsFirestoreService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('Patients');

  Future<void> addPatient(
      String firstName,
      String lastName,
      String phoneNumber,
      DateTime birthDate,
      bool hasRhinits,
      bool hasAsthma,
      String uid,
      String otp) async {
    await _patientsCollection.add({
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'has_allergic_rhinitis': hasRhinits,
      'has_asthma': hasAsthma,
      'otp': otp
    });
  }

  Stream<List<Patient>> getPatients() {
    return _patientsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Patient.fromFirestore(doc)).toList());
  }

  Future<List<DosageData>> getSortedDosageData(String userId) async {
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
          isHospital: data['is_hospital_dosage'],
          watering: data.containsKey('watering') ? data['watering'] : null,
        );
      }).toList();

      return dosageData;
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      return [];
    }
  }

  Future<List<SymptomData>> getSymptomsData(String userId) async {
    try {
      CollectionReference symptomsCollection = FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Symptom Recordings');

      QuerySnapshot snapshot =
          await symptomsCollection.orderBy("symptom_date").get();

      List<SymptomData> symptomsData = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SymptomData(
            date: (data['symptom_date'] as Timestamp).toDate(),
            detail: data['detail'] as String,
            type: data['symptom_type'] as String);
      }).toList();

      return symptomsData;
    } catch (e) {
      print('Failed to retrieve symptoms data: $e');
      return [];
    }
  }
}

class DosageData {
  final DateTime date;
  final double amount;
  final bool isHospital;
  final String? watering;
  DosageData(
      {required this.date,
      required this.amount,
      required this.isHospital,
      this.watering});
}

class SymptomData {
  final DateTime date;
  final String detail;
  final String type;

  SymptomData({required this.date, required this.detail, required this.type});
}

class Patient {
  final String firstName;
  final String lastName;
  final String gender;
  final String phoneNumber;
  final DateTime birthDate;
  final String allergyType;
  final bool hasRhinits;
  final bool hasAsthma;
  final bool hasAtopicDermatitis;
  final String uid;
  final String otp;
  final String patientId;

  Patient(
      {required this.firstName,
      required this.lastName,
      required this.gender,
      required this.phoneNumber,
      required this.birthDate,
      required this.allergyType,
      required this.hasRhinits,
      required this.hasAsthma,
      required this.hasAtopicDermatitis,
      required this.uid,
      required this.otp,
      required this.patientId});

  factory Patient.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp birthDateTimestamp = data['birth_date'];
    DateTime birthDate =
        birthDateTimestamp.toDate(); // Convert Timestamp to DateTime
    return Patient(
        firstName: data['first_name'],
        lastName: data['last_name'],
        gender: data['gender'],
        phoneNumber: data['phone_number'],
        birthDate: birthDate, // Assign the converted birthDate
        allergyType: data['allergy_type'],
        hasRhinits: data['has_allergic_rhinitis'],
        hasAsthma: data['has_asthma'],
        hasAtopicDermatitis: data['has_atopic_dermatitis'],
        uid: data['uid'],
        otp: data['otp'],
        patientId: data['patient_id']);
  }
}
