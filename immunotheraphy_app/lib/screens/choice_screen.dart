import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/notification_test.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the device has a small screen (e.g., iPhone SE)
    final isSmallScreen = MediaQuery.of(context).size.height <= 667.0;

    // Adjust the title font size based on the screen size
    final double titleFontSize = isSmallScreen ? 22.0 : 26.0;

    // Adjust the choice box size based on the screen size
    final double choiceBoxSize = isSmallScreen ? 230.0 : 271.0;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding:
              const EdgeInsets.only(top: 20.0), // Add top padding to the title
          child: Text(
            AppLocalizations.of(context)!.appTitle,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: titleFontSize,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationTestPage(),
                  ),
                );
              },
              child: Container(
                width: choiceBoxSize,
                height: choiceBoxSize,
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
                    Image.asset(
                      'assets/images/patient_card_upscaled.png',
                      width: choiceBoxSize * 0.65,
                      height: choiceBoxSize * 0.65,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.patientSignIn,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18.0 : 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 30 : 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorSignInScreen(),
                  ),
                );
              },
              child: Container(
                width: choiceBoxSize,
                height: choiceBoxSize,
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
                    Image.asset(
                      'assets/images/doctor_card_upscaled.png',
                      width: choiceBoxSize * 0.65,
                      height: choiceBoxSize * 0.65,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.doctorSignIn,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18.0 : 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
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
