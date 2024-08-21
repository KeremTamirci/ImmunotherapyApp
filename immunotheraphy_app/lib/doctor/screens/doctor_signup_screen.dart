import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({Key? key}) : super(key: key);

  @override
  _DoctorSignUpScreenState createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _surnameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _tokenTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DoctorsFirestoreService _firestoreService = DoctorsFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.signUp,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.name,
                  Icons.person_outline,
                  false,
                  _nameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.surname,
                  Icons.person_outline,
                  false,
                  _surnameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.enterPhone,
                  Icons.phone_iphone,
                  false,
                  _phoneTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.enterEmail,
                  Icons.mail_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.enterPassword,
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.confirmPassword,
                  Icons.lock_outline,
                  true,
                  _confirmPasswordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Token",
                  Icons.security_outlined,
                  false,
                  _tokenTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, AppLocalizations.of(context)!.signUp,
                    () {
                  String password = _passwordTextController.text;
                  String confirmPassword = _confirmPasswordTextController.text;
                  String token = _tokenTextController.text;

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.passwordMismatch),
                      ),
                    );
                    return;
                  }

                  if (token != "KOC24") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.invalidToken),
                      ),
                    );
                    return;
                  }

                  _auth
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: password,
                  )
                      .then((value) async {
                    _firestoreService
                        .addDoctor(
                      _nameTextController.text,
                      _surnameTextController.text,
                      _phoneTextController.text,
                      value.user!.uid,
                      await _firebaseMessaging.getToken() ?? " ",
                      _tokenTextController.text,
                    )
                        .then((_) {
                      print("User added to Firestore");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DoctorHomeScreen()),
                        (_) => false,
                      );
                    }).catchError((error) {
                      print("Failed to add user to Firestore: $error");
                      // Handle Firestore errors if needed
                    });
                  }).catchError((error) {
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
