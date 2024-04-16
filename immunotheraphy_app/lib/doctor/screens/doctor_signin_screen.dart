import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/reset_password.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signup_screen.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter/material.dart';

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
        title: Text('Doctor Sign In'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: hexStringToColor("6495ED"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
//          hexStringToColor("CB2B93"),
//          hexStringToColor("9546C4"),
//          hexStringToColor("5E61F4")
          hexStringToColor("6495ED"),
          hexStringToColor("3DED97")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/doctor_card.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () async {
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text);
                    // Sign-in successful, navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorHomeScreen()),
                    );
                  } catch (error) {
                    print("Error: ${error.toString()}");
                    // Handle the error gracefully, e.g., show a dialog or a snackbar
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content:
                              Text("An error occurred: ${error.toString()}"),
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
                }),
                signUpOption()
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
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DoctorSignUpScreen()));
          },
          child: const Text(
            " Sign Up",
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
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => DoctorResetPassword())),
      ),
    );
  }
}
