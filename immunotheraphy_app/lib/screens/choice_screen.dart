import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:immunotheraphy_app/utils/color_utils.dart';

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
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ),
        centerTitle: true, // Center the title horizontally
        elevation: 0, // Remove elevation (shadow) from the app bar
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PatientSignInScreen(),
                //   ),
                // );
                Navigator.push(
                  context,
                  _createRoute("Hasta"),
                );
              },
              child: Container(
                width: 271,
                height: 271,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hexStringToColor("2E5984"),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/patient_card.png',
                        width: 175,
                        height:
                            175), // Replace 'assets/patient_image.png' with your actual image path
                    const SizedBox(height: 30),
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
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DoctorSignInScreen(),
                //   ),
                // );
                Navigator.push(
                  context,
                  _createRoute("Doktor"),
                );
              },
              child: Container(
                width: 271,
                height: 271,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: hexStringToColor("4E5166"),
                  color: hexStringToColor("2E5984"),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(5, 5), // changes position of shadow
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/doctor_card.png',
                        width: 175,
                        height:
                            175), // Replace 'assets/doctor_image.png' with your actual image path
                    SizedBox(height: 30),
                    const Text(
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

Route _createRoute(String route) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOutCubic;
  const ThreePointCubic fastEaseInToSlowEaseOut = ThreePointCubic(
    Offset(0.056, 0.024),
    Offset(0.108, 0.3085),
    Offset(0.198, 0.541),
    Offset(0.3655, 1.0),
    Offset(0.5465, 0.989),
  );

  var tween = Tween(begin: begin, end: end)
      .chain(CurveTween(curve: fastEaseInToSlowEaseOut));

  if (route == "Doktor") {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DoctorSignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  } else if (route == "Hasta") {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PatientSignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  } else {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PatientSignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
