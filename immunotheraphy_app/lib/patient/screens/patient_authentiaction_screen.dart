import 'package:immunotheraphy_app/patient/screens/home_page.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

import 'patient_home_screen.dart';

class PatientAuthenticationScreen extends StatefulWidget {
  const PatientAuthenticationScreen({Key? key}) : super(key: key);

  @override
  _PatientAuthenticationScreenState createState() =>
      _PatientAuthenticationScreenState();
}

class _PatientAuthenticationScreenState
    extends State<PatientAuthenticationScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  "Email",
                  Icons.email,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Password",
                  Icons.lock,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Confirm Password",
                  Icons.lock,
                  true,
                  _confirmPasswordTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  _signUpPatient();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpPatient() async {
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    String confirmPassword = _confirmPasswordTextController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Navigate to HomeScreen after successful sign up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientHomeScreen()),
        );
      }
    } catch (e) {
      print('Error signing up patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}
