import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientSignInScreen(),
                  ),
                );
              },
              child: Text('I am a Patient'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorSignInScreen(),
                  ),
                );
              },
              child: Text('I am a Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
