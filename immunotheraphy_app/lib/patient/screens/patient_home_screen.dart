import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:flutter/material.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  late User _user;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${_user.displayName ?? 'Guest'}!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PatientSignInScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
