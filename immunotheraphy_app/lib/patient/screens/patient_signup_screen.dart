import 'package:flutter/gestures.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:immunotheraphy_app/patient/screens/patient_authentiaction_screen.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/home_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(
          AppLocalizations.of(context)!.signUp,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1a80e5), Color(0xff2e5984)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.phoneNumber,
                  Icons.phone,
                  false,
                  _phoneNumberTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.otp,
                  Icons.lock_outlined,
                  true,
                  _otpTextController,
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!.byContinuing),
                      TextSpan(
                        text: AppLocalizations.of(context)!.termsOfUse,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openBottomSheet(
                                AppLocalizations.of(context)!.termsOfService);
                          },
                      ),
                      if (AppLocalizations.of(context)!.accept != "Accept")
                        TextSpan(text: AppLocalizations.of(context)!.accept),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, AppLocalizations.of(context)!.signUp,
                    () {
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
          const SnackBar(
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
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  void _signUpPatient() async {
    try {
      // Sign up logic
      // FirebaseAuth.instance.createUserWithEmailAndPassword...

      // Navigate to HomeScreen after successful sign up and remove all routes until the new route
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PatientAuthenticationScreen(
            otp: _otpTextController.text,
            phoneNumber: _phoneNumberTextController.text,
          ),
        ),
        (_) => false, // Remove all routes
      );
    } catch (e) {
      print('Error signing up patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  void _openBottomSheet(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
