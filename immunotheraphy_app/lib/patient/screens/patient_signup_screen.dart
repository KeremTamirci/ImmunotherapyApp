import 'package:immunotheraphy_app/patient/screens/home_page.dart';
import 'package:immunotheraphy_app/patient/screens/patient_authentiaction_screen.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/home_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PatientSignUpScreen extends StatefulWidget {
  const PatientSignUpScreen({Key? key}) : super(key: key);

  @override
  _PatientSignUpScreenState createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends State<PatientSignUpScreen> {
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _otpTextController = TextEditingController();

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
                  "Phone Number",
                  Icons.phone,
                  false,
                  _phoneNumberTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "One Time Password",
                  Icons.lock_outlined,
                  true,
                  _otpTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  _checkPatientExists();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkPatientExists() async {
    String phoneNumber = _phoneNumberTextController.text;
    String otp = _otpTextController.text;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Temp_Patients')
          .where('phone_number', isEqualTo: phoneNumber)
          .where('otp', isEqualTo: otp)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Patient with the same phone number and OTP exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid entry.'),
          ),
        );
      } else {
        // No patient exists with the same phone number and OTP, proceed with sign up
        _signUpPatient();
      }
    } catch (e) {
      print('Error checking patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  void _signUpPatient() async {
    try {
      // Sign up logic
      // FirebaseAuth.instance.createUserWithEmailAndPassword...
      // Navigate to HomeScreen after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientAuthenticationScreen(otp:_otpTextController.text, phoneNumber: _phoneNumberTextController.text,)),
      );
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
