import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/screens/new_patient_page.dart';
import 'package:immunotheraphy_app/doctor/screens/patient_list_screen.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late User _user;
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
        page = const PatientListScreen();
        break;
      case 1:
        page = const NewPatientPage();
        break;
      case 2:
        page = const DoctorProfilePage();
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
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.doctorHomeScreen),
      // ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            ), // sets the inactive color of the `BottomNavigationBar`
        child: SizedBox(
          height: 72,
          child: Wrap(
            children: [
              BottomNavigationBar(
                // backgroundColor: hexStringToColor("1A80E5"),
                backgroundColor: Theme.of(context).colorScheme.background,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: AppLocalizations.of(context)!.home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.sick),
                    label: AppLocalizations.of(context)!.newPatient,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: AppLocalizations.of(context)!.settings,
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
            ],
          ),
        ),
      ),
      body: Center(
        child: mainArea,
      ),
    );
  }
}
