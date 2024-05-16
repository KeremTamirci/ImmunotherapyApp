import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late User _user;
  late Map<String, dynamic> _doctorData = {};
  bool gotData = false;
  final Text homeScreenTitle = const Text("Doctor Home Screen");
  final Text logOutText = const Text("Log Out");
  final TextStyle style = const TextStyle(fontSize: 20);

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
      await _getDoctorData(user.uid);
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
        gotData = true;
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
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
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
                        builder: (context) => const DoctorSignInScreen()),
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
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mm'),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          '${_doctorData['first_name'][0].toUpperCase()}${_doctorData['first_name'].substring(1)} ',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: _doctorData['last_name'].toUpperCase(),
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'email: ${_user.email}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Phone Number: ${_doctorData['phone_number']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
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
