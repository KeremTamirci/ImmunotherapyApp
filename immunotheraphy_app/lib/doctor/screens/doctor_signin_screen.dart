import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/reset_password.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signup_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorSignIn),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Color(0xff2e5984),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2e5984),
              Color(0xff1a80e5)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.18,
              20,
              20, // Add bottom padding here
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/doctor_card.png"),
                const SizedBox(height: 30),
                reusableTextField(
                  AppLocalizations.of(context)!.enterEmail,
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.enterPassword,
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                ),
                const SizedBox(height: 5),
                forgetPassword(context),
                firebaseUIButton(
                  context,
                  AppLocalizations.of(context)!.signIn,
                  () async {
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );
                      // Sign-in successful, navigate to the next screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
                        (_) => false,
                      );
                    } catch (error) {
                      print("Error: ${error.toString()}");
                      // Handle the error gracefully, e.g., show a dialog or a snackbar
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("An error occurred: ${error.toString()}"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                signUpOption(),
                Padding(padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.18,
              20,
              20, // Add bottom padding here
            )), // Padding added under the sign-up button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dontHaveAnAccount,
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorSignUpScreen()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.signUp,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
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
          MaterialPageRoute(builder: (context) => DoctorResetPassword()),
        ),
      ),
    );
  }
}
