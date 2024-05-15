import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/patient/utils/date_format.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  late Map<String, dynamic> _patientData = {};
  late Map<String, dynamic> _doctorData = {};
  final Text homeScreenTitle = const Text("Patient Home Screen");
  final Text logOutText = const Text("Log Out");
  final TextStyle style = const TextStyle(fontSize: 20);
  bool gotData = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      await _getPatientData(user.uid);
    }
  }

  Future<void> _getPatientData(String patientId) async {
    try {
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .get();

      if (patientSnapshot.exists) {
        setState(() {
          _patientData = patientSnapshot.data() as Map<String, dynamic>;
        });
        await _getDoctorData(_patientData['uid']);
        gotData = true;
      }
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  Future<void> _getDoctorData(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId)
          .get();

      if (doctorSnapshot.exists) {
        setState(() {
          _doctorData = doctorSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to sign out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientSignInScreen()),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: _getUserData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (!gotData) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mm'),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: _patientData['first_name'],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ' + _patientData['last_name'],
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${_user.email}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Phone Number: ${_patientData['phone_number']}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Has Allergic Rhinitis: ${_patientData['has_allergic_rhinitis'] ? 'Yes' : 'No'}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Has Asthma: ${_patientData['has_asthma'] ? 'Yes' : 'No'}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Birth Date: ${DateFormatHelper.formatDate(_patientData['birth_date'])}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Doctor: ${_doctorData['first_name']} ${_doctorData['last_name']}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: logOutText,
                    onPressed: () {
                      _confirmSignOut(context);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
