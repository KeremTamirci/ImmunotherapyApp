import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late User _user;
  late Future<void> _userDataFuture;
  late Map<String, dynamic> _doctorData = {};
  bool gotData = false;
  final TextStyle style = const TextStyle(fontSize: 20);
  late String selectedLanguage = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    _loadLanguagePreference(); // Load language preference
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
      await _getDoctorData(user.uid);
    }
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('preferredLanguage') ??
          'en'; // Default language is English
    });
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLanguage', languageCode);
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  Future<void> _getDoctorData(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId)
          .get();

      if (doctorSnapshot.exists) {
        if (mounted) {
          setState(() {
            _doctorData = doctorSnapshot.data() as Map<String, dynamic>;
            gotData = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching doctor data: $e');
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: CupertinoColors.systemBackground,
          title: DialogTitleText(AppLocalizations.of(context)!.confirm),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DialogText(AppLocalizations.of(context)!.signOutSure),
              ],
            ),
          ),
          actions: <Widget>[
            DialogTextButton(
              AppLocalizations.of(context)!.cancel,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            DialogTextButton(
              AppLocalizations.of(context)!.logOut,
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const ChoiceScreen()),
                    (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _userDataFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const CircleAvatar(
                //   radius: 60,
                //   backgroundImage: NetworkImage(
                //       'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mm'),
                // ),
                const Icon(
                  Icons.person,
                  size: 120,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: _doctorData['first_name'] +
                        ' ' +
                        _doctorData['last_name'],
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                // const SizedBox(height: 10),
                MainTextButton(
                  "Change language/Dili değiştir",
                  onPressed: () {
                    _showLanguageSelector(context);
                  },
                ),
                // const SizedBox(height: 10),
                CupertinoList(dataPairs: [
                  {'titleText': 'Email', 'textValue': _user.email},
                  {
                    'titleText': AppLocalizations.of(context)!.phoneNumber,
                    'textValue': _doctorData['phone_number']
                  }
                ]),
                // Text(
                //   'email: ${_user.email}',
                //   style: const TextStyle(fontSize: 20, color: Colors.black),
                // ),
                // Text(
                //   '${AppLocalizations.of(context)!.phoneNumber}: ${_doctorData['phone_number']}',
                //   style: const TextStyle(fontSize: 20, color: Colors.black),
                // ),ş
                const SizedBox(height: 20),
                // ElevatedButton(
                //   child: Text(AppLocalizations.of(context)!.logOut),
                //   onPressed: () {
                //     _confirmSignOut(context);
                //   },
                // ),
                MainElevatedButton(
                  AppLocalizations.of(context)!.logOut,
                  onPressed: () {
                    _confirmSignOut(context);
                  },
                  widthFactor: 0.9,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          surfaceTintColor: CupertinoColors.systemBackground,
          title: const DialogTitleText('Select Language/Dili Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const DialogText('English'),
                trailing: selectedLanguage == 'en'
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'en';
                  });
                  _saveLanguagePreference(selectedLanguage);
                  _showLanguageSnackbarEnglish();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const DialogText('Türkçe'),
                trailing: selectedLanguage == 'tr'
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'tr';
                  });
                  _saveLanguagePreference(selectedLanguage);
                  _showLanguageSnackbarTurkish();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSnackbarTurkish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dilin değişmesi için uygulamayı tamamen kapatıp açın'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLanguageSnackbarEnglish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'For the change of language to take effect completely restart the application'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
