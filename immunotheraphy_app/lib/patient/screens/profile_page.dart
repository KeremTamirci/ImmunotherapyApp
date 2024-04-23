import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Center(
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
    );
  }
}
