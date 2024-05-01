import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final PatientsFirestoreService _patientsFirestoreService = PatientsFirestoreService();
  late List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    List<Patient> fetchedPatients = await _patientsFirestoreService.getPatients().first;
    setState(() {
      patients = fetchedPatients;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Patient List'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Patient List'),
        ),
        body: ListView.builder(
          itemCount: patients.length,
          itemBuilder: (context, index) {
            Patient patient = patients[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: IconTheme(
                  data: IconThemeData(size: 36), // Adjust the size here
                  child: Icon(Icons.person),
                ),
                title: Text(
                  '${patient.firstName} ${patient.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text('Phone: ${patient.phoneNumber}'),
                    SizedBox(height: 2),
                    Text('Birth Date: ${_formatDate(patient.birthDate)}'),
                    SizedBox(height: 2),
                    Text('Has Rhinitis: ${patient.hasRhinits ? 'Yes' : 'No'}'),
                    SizedBox(height: 2),
                    Text('Has Asthma: ${patient.hasAsthma ? 'Yes' : 'No'}'),
                  ],
                ),
                onTap: () {
                  // Handle onTap event if needed
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
