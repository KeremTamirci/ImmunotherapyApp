import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:flutter/material.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  late User _user;
  final Text homeScreenTitle = const Text("Patient Home Screen");
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: homeScreenTitle,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${_user.displayName ?? 'Guest'}!',
              style: style,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: logOutText,
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
        ),
      ),
    );
  }
}
