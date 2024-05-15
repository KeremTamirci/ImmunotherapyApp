// ignore_for_file: use_super_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/api/firebase_api.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_home_screen.dart';
import 'package:immunotheraphy_app/patient/screens/patient_home_screen.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff1a80e5),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff1a80e5),
          onPrimary: Color.fromARGB(255, 242, 242, 247),
          secondary: Color(0xff2e5984),
          onSecondary: Color.fromARGB(255, 242, 242, 247),
          error: Color(0xff1a80e5),
          onError: Color(0xff1a80e5),
          background: Color.fromARGB(255, 242, 242, 247),
          onBackground: Color.fromARGB(255, 0, 0, 0),
          surface: Color.fromARGB(255, 242, 242, 247),
          onSurface: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasData) {
          return UserTypeChecker(user: snapshot.data!);
        } else {
          return const ChoiceScreen();
        }
      },
    );
  }
}

class UserTypeChecker extends StatelessWidget {
  final User user;

  const UserTypeChecker({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: FirebaseApi().isDoctor(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasData) {
          if (snapshot.data!) {
            return const DoctorHomeScreen();
          } else {
            return const PatientHomeScreen();
          }
        } else {
          return const Text('Error determining user type');
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
