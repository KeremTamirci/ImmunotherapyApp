import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/patient/screens/patient_signin_screen.dart';
import 'package:immunotheraphy_app/patient/utils/date_format.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  late Map<String, dynamic> _patientData = {};
  late Map<String, dynamic> _doctorData = {};
  final TextStyle style = const TextStyle(fontSize: 20);
  bool gotData = false;
  late String selectedLanguage = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadLanguagePreference(); // Load language preference
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      await _getPatientData(user.uid);
    }
  }

  Future<void> _getPatientData(String patientId) async {
    try {
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .get();

      if (patientSnapshot.exists) {
        setState(() {
          _patientData = patientSnapshot.data() as Map<String, dynamic>;
        });
        await _getDoctorData(_patientData['uid']);
        gotData = true;
      }
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  Future<void> _getDoctorData(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId)
          .get();

      if (doctorSnapshot.exists) {
        setState(() {
          _doctorData = doctorSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
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
                DialogText(AppLocalizations.of(context)!.signOutSure)
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
            DialogElevatedButton(
              AppLocalizations.of(context)!.logOut,
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
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
    return CupertinoPageScaffold(
      child: Center(
        child: FutureBuilder(
          future: _getUserData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (!gotData) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  // const Spacer(),
                  // const CircleAvatar(
                  //   radius: 60,
                  //   backgroundImage: NetworkImage(
                  //       'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mm'),
                  // ),
                  const Icon(
                    Icons.person,
                    size: 120,
                  ),
                  // const SizedBox(height: 20),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: _patientData['first_name'] +
                            ' ' +
                            _patientData['last_name'],
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        // children: <TextSpan>[
                        //   TextSpan(
                        //     text: ' ' + _patientData['last_name'],
                        //     style: const TextStyle(
                        //         fontSize: 28,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // const Spacer(),
                  MainTextButton(
                    "Change language/Dili değiştir",
                    onPressed: () {
                      _showLanguageSelector(context);
                    },
                  ),
                  // const Spacer(),
                  PatientInfoBox(
                      user: _user,
                      patientData: _patientData,
                      doctorData: _doctorData),
                  // const SizedBox(height: 30),
                  AdditionalInfoBox(patientData: _patientData),
                  //////////////////////////////////////////////////////////
                  // const SizedBox(height: 20),
                  const Spacer(),
                  // Button to change language
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _showLanguageSelector(context);
                  //   },
                  //   child: const Text('Change Language/Dili Değiştir'),
                  // ),
                  ///////////// BURADAYDI //////////////////
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _confirmSignOut(context);
                  //   },
                  //   child: Text(AppLocalizations.of(context)!.logOut),
                  // ),
                  // const SizedBox(height: 20),
                  // const Spacer(),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const SizedBox(height: 10),
                  MainElevatedButton(
                    AppLocalizations.of(context)!.logOut,
                    onPressed: () {
                      _confirmSignOut(context);
                    },
                    widthFactor: 0.9,
                  ),
                  const Spacer(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              );
            }
          },
        ),
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

class AdditionalInfoBox extends StatelessWidget {
  const AdditionalInfoBox({
    super.key,
    required Map<String, dynamic> patientData,
  }) : _patientData = patientData;

  final Map<String, dynamic> _patientData;

  @override
  Widget build(BuildContext context) {
    return CupertinoList(
        // title: "Additional Information",
        dataPairs: [
          {
            'titleText': AppLocalizations.of(context)!.hasRhinitis,
            'textValue': _patientData['has_allergic_rhinitis']
                ? AppLocalizations.of(context)!.yes
                : AppLocalizations.of(context)!.no
          },
          {
            'titleText': AppLocalizations.of(context)!.hasAsthma,
            'textValue': _patientData['has_asthma']
                ? AppLocalizations.of(context)!.yes
                : AppLocalizations.of(context)!.no
          },
        ]);
  }
}

class PatientInfoBox extends StatelessWidget {
  const PatientInfoBox({
    super.key,
    required User user,
    required Map<String, dynamic> patientData,
    required Map<String, dynamic> doctorData,
  })  : _user = user,
        _patientData = patientData,
        _doctorData = doctorData;

  final User _user;
  final Map<String, dynamic> _patientData;
  final Map<String, dynamic> _doctorData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoList(
        dataPairs: [
          {'titleText': 'Email', 'textValue': _user.email},
          {
            'titleText': AppLocalizations.of(context)!.phoneNumber,
            'textValue': _patientData['phone_number']
          },
          {
            'titleText': AppLocalizations.of(context)!.birthDate,
            'textValue': DateFormatHelper.formatDate(_patientData['birth_date'])
          },
          {
            'titleText': AppLocalizations.of(context)!.doctor,
            'textValue':
                '${_doctorData['first_name']} ${_doctorData['last_name']}'
          },
        ],
      ),
    );
  }
}
