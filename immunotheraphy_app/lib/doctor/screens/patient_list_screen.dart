import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/screens/patient_detail_page.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  PatientListScreenState createState() => PatientListScreenState();
}

class PatientListScreenState extends State<PatientListScreen> {
  final PatientsFirestoreService _patientsFirestoreService =
      PatientsFirestoreService();
  late List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    // Get the current user (doctor) UID
    String currentDoctorUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Fetch patients associated with the current doctor UID
    List<Patient> fetchedPatients = await _patientsFirestoreService
        .getPatients()
        .first
        .then((List<Patient> patients) => patients
            .where((patient) => patient.uid == currentDoctorUID)
            .toList());

    setState(() {
      patients = fetchedPatients;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title:  Text(AppLocalizations.of(context)!.patientList),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.patientList),
        ),
        body: ListView.builder(
          itemCount: patients.length,
          itemBuilder: (context, index) {
            Patient patient = patients[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: const IconTheme(
                  data: IconThemeData(size: 36), // Adjust the size here
                  child: Icon(Icons.person),
                ),
                title: Text(
                  '${patient.firstName} ${patient.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context)!.phoneNumber + patient.phoneNumber),
                  const SizedBox(height: 2),
                  Text('${AppLocalizations.of(context)!.birthDate} ${_formatDate(patient.birthDate)}'),
                  const SizedBox(height: 2),
                  Text('${AppLocalizations.of(context)!.hasRhinitis}: ${patient.hasRhinits  ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),
                  const SizedBox(height: 2),
                  Text('${AppLocalizations.of(context)!.hasAsthma}: ${patient.hasAsthma ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),

                  ],
                ),
                onTap: () {
                  // Navigate to PatientDetailScreen and pass the selected patient
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailScreen(patient: patient),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}'; // Format date as desired
  }
}
