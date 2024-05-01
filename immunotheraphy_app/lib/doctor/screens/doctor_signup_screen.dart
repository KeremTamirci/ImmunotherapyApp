import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/home_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart'; 

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({Key? key}) : super(key: key);

  @override
  _DoctorSignUpScreenState createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _surnameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _tokenTextController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DoctorsFirestoreService _firestoreService = DoctorsFirestoreService();

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
                  "Name",
                  Icons.person_outline,
                  false,
                  _nameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Surname",
                  Icons.person_outline,
                  false,
                  _surnameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Email",
                  Icons.mail_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Token",
                  Icons.security_outlined,
                  false,
                  _tokenTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  _auth
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    _firestoreService.addDoctor(
                      _nameTextController.text,
                      _surnameTextController.text,
                      _tokenTextController.text,
                      value.user!.uid,
                    ).then((_) {
                      print("User added to Firestore");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
                      );
                    }).catchError((error) {
                      print("Failed to add user to Firestore: $error");
                      // Handle Firestore errors if needed
                    });
                  })
                      .catchError((error) {
                    print("Error: $error");
                    // Handle sign up errors if needed
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
