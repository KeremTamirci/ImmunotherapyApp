import 'package:firebase_core/firebase_core.dart';
import 'package:immunotheraphy_app/firebase_options.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';
// import 'package:immunotheraphy_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xff1a80e5),
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff1a80e5),
              onPrimary: Color.fromARGB(255, 243, 240, 231),
              secondary: Color(0xff2e5984),
              onSecondary: Color.fromARGB(255, 243, 240, 231),
              error: Color(0xff1a80e5),
              onError: Color(0xff1a80e5),
              background: Color.fromARGB(255, 243, 240, 231),
              // background: Color.fromARGB(255, 242, 242, 247),
              onBackground: Color.fromARGB(255, 0, 0, 0),
              surface: Color.fromARGB(255, 243, 240, 231),
              onSurface: Color.fromARGB(255, 0, 0, 0))),
      home: const ChoiceScreen(),
    );
  }
}
