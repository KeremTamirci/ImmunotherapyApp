import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/screens/language_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:immunotheraphy_app/firebase_options.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';

import 'api/firebase_api.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? preferredLanguage = prefs.getString('preferredLanguage');

  // If preferred language is not set, initialize it to the default locale (Turkish)
  if (preferredLanguage == null) {
    // Retrieve the device's locale
    String locale = Platform.localeName;
    // Extract language code from locale string
    String languageCode = locale.split('_')[0];
    // Check if the device's locale is supported, if not default to Turkish
    preferredLanguage = ['en', 'tr'].contains(languageCode) ? languageCode : 'en';
    // Save the default language to SharedPreferences
    await prefs.setString('preferredLanguage', preferredLanguage);
  }

  runApp(MyApp(preferredLanguage: preferredLanguage));
}


class MyApp extends StatelessWidget {
  final String? preferredLanguage;

  const MyApp({Key? key, this.preferredLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("tr"),
      ],
      locale: preferredLanguage != null ? Locale(preferredLanguage!) : null,
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
      home: preferredLanguage != null ? const ChoiceScreen() : LanguageSelectionScreen(),
    );
  }
}
