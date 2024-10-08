import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/reset_password.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signup_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

class DoctorSignInScreen extends StatefulWidget {
  const DoctorSignInScreen({Key? key}) : super(key: key);

  @override
  _DoctorSignInScreenState createState() => _DoctorSignInScreenState();
}

class _DoctorSignInScreenState extends State<DoctorSignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height <= 667.0;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.doctorSignIn),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: const Color(0xff1a80e5),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
//          hexStringToColor("CB2B93"),
//          hexStringToColor("9546C4"),
//          hexStringToColor("5E61F4")
          Color(0xff1a80e5),
          Color(0xff2e5984)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height *
                    (isSmallScreen ? 0.01 : 0.18),
                20,
                0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/doctor_card_upscaled.png"),
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
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevents dismissing the dialog by tapping outside
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
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
                          firestore.collection('Doctors').doc(test_uid);

                      final docSnapshot = await docRef.get();

                      if (docSnapshot.exists) {
                        print('User exists in Doctors collection');
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoctorHomeScreen()),
                            (_) => false);
                      } else {
                        print('User does not exist in Doctors collection');
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);

                        _emailTextController.clear();
                        _passwordTextController.clear();

                        _showNotADoctorDialog(context);
                      }
                    }
                  } catch (error) {
                    print("Error: ${error.toString()}");
                    Navigator.pop(context);
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

  void _showNotADoctorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: DialogTitleText(AppLocalizations.of(context)!.cannotSignIn),
          content: DialogText(AppLocalizations.of(context)!.cannotSignInDoctor),
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
            style: const TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DoctorSignUpScreen()));
          },
          child: Text(
            AppLocalizations.of(context)!.signUp,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
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
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DoctorResetPassword())),
      ),
    );
  }
}
