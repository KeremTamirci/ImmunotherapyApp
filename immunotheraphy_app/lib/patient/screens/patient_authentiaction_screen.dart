import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/screens/terms_of_service_page.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/patient/screens/patient_home_screen.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientAuthenticationScreen extends StatefulWidget {
  final String otp;
  final String phoneNumber;

  const PatientAuthenticationScreen({
    Key? key,
    required this.otp,
    required this.phoneNumber,
  }) : super(key: key);

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

  late DatabaseController _databaseController;

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
                  AppLocalizations.of(context)!.enterEmail,
                  Icons.email,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.enterPassword,
                  Icons.lock,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  AppLocalizations.of(context)!.confirmPassword,
                  Icons.lock,
                  true,
                  _confirmPasswordTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, AppLocalizations.of(context)!.signUp,
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
                    // ignore: unused_local_variable
                    _signUpPatient();
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
          content: Text(AppLocalizations.of(context)!.passwordMismatch),
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
        print(userCredential.user!.uid);
        _databaseController = DatabaseController(
            userCredential.user!.uid, userCredential.user!.displayName);
        await _databaseController.processTempPatientRecord(
            widget.otp, widget.phoneNumber, userCredential.user!.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TermsOfServicePage()),
        );
      }
    } catch (e) {
      print('Error signing up patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}
