import 'dart:async'; // Import to use StreamSubscription

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  StreamSubscription<List<Patient>>? _patientsSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() {
    // Get the current user (doctor) UID
    String currentDoctorUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Subscribe to the patients stream and update the state
    _patientsSubscription = _patientsFirestoreService.getPatients().listen(
        (List<Patient> fetchedPatients) {
      List<Patient> filteredPatients = fetchedPatients
          .where((patient) => patient.uid == currentDoctorUID)
          .toList();

      if (mounted) {
        setState(() {
          patients = filteredPatients;
          _isLoading = false;
        });
      }
    }, onError: (error) {
      // Handle error if needed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _patientsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.patientList),
        surfaceTintColor: CupertinoColors.systemBackground,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : patients.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16.0), // Rounded corners
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 2,
                      //     offset: Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.noPatientsFound,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    Patient patient = patients[index];
                    return Card(
                      color: CupertinoColors.systemBackground,
                      surfaceTintColor: CupertinoColors.systemBackground,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
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
                            Text(
                                '${AppLocalizations.of(context)!.phoneNumber} ${patient.phoneNumber}'),
                            const SizedBox(height: 2),
                            Text(
                                '${AppLocalizations.of(context)!.birthDate} ${_formatDate(patient.birthDate)}'),
                            const SizedBox(height: 2),
                            Text(
                                '${AppLocalizations.of(context)!.hasRhinitis}: ${patient.hasRhinits ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),
                            const SizedBox(height: 2),
                            Text(
                                '${AppLocalizations.of(context)!.hasAsthma}: ${patient.hasAsthma ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),
                          ],
                        ),
                        onTap: () {
                          // Navigate to PatientDetailScreen and pass the selected patient
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PatientDetailScreen(patient: patient),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}'; // Format date as desired
  }
}
