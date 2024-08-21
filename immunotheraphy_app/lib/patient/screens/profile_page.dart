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
  String _notificationTime = '-'; // Add this line
  bool _notificationsEnabled = false;

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
      await _getPatientData(user.uid, user.displayName);
    }
  }

  Future<void> _getPatientData(String patientId, String? hospitalToken) async {
    try {
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(hospitalToken)
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

  Future<void> _loadNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? timeString = prefs.getString('selectedTime');

    setState(() {
      _notificationTime = timeString ?? '-';

      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _clearNotificationTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedTime');
    await prefs.remove("notificationsEnabled");

    _loadNotificationData(); // Refresh notification time immediately
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
              onPressed: () async {
                await _clearNotificationTime(); // Clear preferences before signing out
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
    final isSmallScreen = MediaQuery.of(context).size.height <= 667.0;
    return CupertinoPageScaffold(
      child: Center(
        child: FutureBuilder(
          future: Future.wait([
            _getUserData(),
            _loadNotificationData()
          ]), // Ensure notification time is loaded
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (!gotData) {
              return const CircularProgressIndicator();
            } else {
              return CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isSmallScreen
                          ? Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                const Icon(
                                  Icons.person,
                                  size: 120,
                                ),
                              ],
                            )
                          : SizedBox
                              .shrink(), // Use SizedBox.shrink() to occupy no space when not visible

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
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
                          ),
                        ),
                      ),
                      MainTextButton(
                        "Change language/Dili değiştir",
                        onPressed: () {
                          _showLanguageSelector(context);
                        },
                      ),
                      PatientInfoBox(
                          user: _user,
                          patientData: _patientData,
                          doctorData: _doctorData,
                          notificationTime: _notificationsEnabled
                              ? _notificationTime
                              : AppLocalizations.of(context)!
                                  .disabled), // Pass the notification time
                      AdditionalInfoBox(patientData: _patientData),
                      const SizedBox(height: 10),
                      MainElevatedButton(
                        AppLocalizations.of(context)!.logOut,
                        onPressed: () {
                          _confirmSignOut(context);
                        },
                        widthFactor: 0.9,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                    ],
                  ),
                ),
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
    required this.notificationTime,
  })  : _user = user,
        _patientData = patientData,
        _doctorData = doctorData;

  final User _user;
  final Map<String, dynamic> _patientData;
  final Map<String, dynamic> _doctorData;
  final String notificationTime;

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
          {
            'titleText': AppLocalizations.of(context)!.doseReminderTime,
            'textValue':
                notificationTime, // Use the notification time passed from ProfilePage
            "hasChevron": "0"
          },
        ],
      ),
    );
  }
}
