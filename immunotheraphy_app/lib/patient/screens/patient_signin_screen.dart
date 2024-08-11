import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/patient/screens/patient_home_screen.dart';
import 'package:immunotheraphy_app/patient/screens/reset_password.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signup_screen.dart';
// import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

class PatientSignInScreen extends StatefulWidget {
  const PatientSignInScreen({Key? key}) : super(key: key);

  @override
  _PatientSignInScreenState createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorSchemeContext = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.height <= 667.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.patientSignIn),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
//          hexStringToColor("CB2B93"),
//          hexStringToColor("9546C4"),
//          hexStringToColor("5E61F4")

//          hexStringToColor("6495ED"),
//          hexStringToColor("3DED97")
          // Color(0xffffffff),
          // Color(0xffffffff),
          Color(0xff1a80e5),
          Color(0xff2e5984)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            // color: Color.fromARGB(255, 243, 240, 231),
            ),
        child: SingleChildScrollView(
          // controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height *
                    (isSmallScreen ? 0.01 : 0.18),
                20,
                0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/patient_card_upscaled.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                  AppLocalizations.of(context)!.enterEmail,
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  AppLocalizations.of(context)!.enterPassword,
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                ),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, AppLocalizations.of(context)!.signIn,
                    () async {
                  try {
                    // ignore: unused_local_variable
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text);
                    // Sign-in successful, navigate to the next screen
                    final user = userCredential.user;
                    if (user != null) {
                      final test_uid = user.uid;
                      print('User UID: $test_uid');
                      final firestore = FirebaseFirestore.instance;
                      final docRef =
                          firestore.collection('Patients').doc(test_uid);

                      final docSnapshot = await docRef.get();

                      if (docSnapshot.exists) {
                        print('User exists in Patients collection');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PatientHomeScreen()),
                          (_) => false,
                        );
                      } else {
                        print('User does not exist in Patients collection');
                        await FirebaseAuth.instance.signOut();

                        _emailTextController.clear();
                        _passwordTextController.clear();

                        _showNotAPatientDialog(context);
                      }
                    }
                  } catch (error) {
                    print("Error: ${error.toString()}");
                    // Handle the error gracefully, e.g., show a dialog or a snackbar
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          surfaceTintColor: Colors.white,
                          title: DialogTitleText(
                              AppLocalizations.of(context)!.error,
                              color: const Color.fromARGB(255, 126, 6, 0)),
                          content: DialogText(
                              AppLocalizations.of(context)!.invalidPassword),
                          actions: [
                            DialogTextButton(
                              AppLocalizations.of(context)!.tamam,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
                signUpOption(),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotAPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.cannotSignIn),
          content: Text(AppLocalizations.of(context)!.cannotSignInPatient),
          actions: <Widget>[
            DialogTextButton(AppLocalizations.of(context)!.tamam,
                onPressed: () {
              Navigator.of(context).pop();
            })
          ],
        );
      },
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.dontHaveAnAccount,
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PatientSignUpScreen()));
          },
          child: Text(
            AppLocalizations.of(context)!.signUp,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PatientResetPassword())),
      ),
    );
  }
}
