import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Padding(
        padding: EdgeInsets.only(top: 20.0), // Add top padding to the title
        child: Text(
          'Koç Üniversitesi Hastanesi İmmünoterapi Takip Uygulaması',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      centerTitle: true, // Center the title horizontally
      elevation: 0, // Remove elevation (shadow) from the app bar
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientSignInScreen(),
                  ),
                );
              },
              child: Container(
                width: 271,
                height: 271,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/patient_card.png', width: 175, height: 175), // Replace 'assets/patient_image.png' with your actual image path
                    SizedBox(height: 30),
                    const Text(
                      'Hasta Girişi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set font size to 20 points
                        fontWeight: FontWeight.bold, // Set font weight to bold
                        fontFamily: 'Inter', // Set font family to Inter
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorSignInScreen(),
                  ),
                );
              },
              child: Container(
                width: 271,
                height: 271,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/doctor_card.png', width: 175, height: 175), // Replace 'assets/doctor_image.png' with your actual image path
                    SizedBox(height: 30),
                    Text(
                      'Doktor Girişi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set font size to 20 points
                        fontWeight: FontWeight.bold, // Set font weight to bold
                        fontFamily: 'Inter', // Set font family to Inter
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
