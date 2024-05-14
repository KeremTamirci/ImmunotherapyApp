import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/screens/dosage_and_symptom_page.dart';
import 'package:immunotheraphy_app/patient/screens/dose_page.dart';
// import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
// import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/profile_page.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  // ignore: unused_field
  late User _user;
  final Text homeScreenTitle = const Text("Patient Home Screen");
  final Text logOutText = const Text("Log Out");
  final TextStyle style = const TextStyle(fontSize: 20);
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        // page = const HomePage();
        page = const DosageAndSymptomPage();
        break;
      case 1:
        page = const DosePage();
        break;
      case 2:
        page = const ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    var mainArea = ColoredBox(
      color: const Color.fromARGB(0, 188, 188, 253),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: homeScreenTitle,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            ), // sets the inactive color of the `BottomNavigationBar`
        child: Wrap(
          children: [
            SizedBox(
              height: Platform.isIOS
                  ? MediaQuery.of(context).size.height * 0.1
                  : MediaQuery.of(context).size.height * 0.08,
              child: BottomNavigationBar(
                // backgroundColor: hexStringToColor("1A80E5"),
                backgroundColor: Theme.of(context).colorScheme.background,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Ana Sayfa',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_graph),
                    label: 'Dozaj',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Ayarlar',
                  ),
                ],
                currentIndex: selectedIndex,
                unselectedItemColor: Colors.black87,
                showUnselectedLabels: true,
                iconSize: 32,
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                selectedLabelStyle: const TextStyle(fontSize: 16),
                selectedItemColor: hexStringToColor("1A80E5"),
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: mainArea,
      ),
    );
  }
}
