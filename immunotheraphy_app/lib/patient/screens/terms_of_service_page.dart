import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/patient/screens/patient_home_screen.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  String? _agreementChoice;
  late DatabaseController _databaseController;
  late User _user;

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
        _databaseController = DatabaseController(user.uid, user.displayName);
      });
    }
  }

  void _submitAgreement() async {
    if (_agreementChoice != null) {
      bool isAgreed = _agreementChoice == 'agree';

      try {
        await _databaseController.recordUserAgreement(isAgreed);
        // Navigate to the Patient Home Screen after recording agreement
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
          (_) => false,
        );
      } catch (e) {
        print('Error recording agreement: $e');
      }
    } else {
      print('No agreement choice selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.approvalForm,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1a80e5), Color(0xff2e5984)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  AppLocalizations.of(context)!.termsOfService,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RadioListTile<String>(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  AppLocalizations.of(context)!.accept,
                  style: const TextStyle(color: Colors.white),
                ),
                value: 'agree',
                groupValue: _agreementChoice,
                onChanged: (String? value) {
                  setState(() {
                    _agreementChoice = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return Colors.white.withOpacity(
                        states.contains(MaterialState.selected) ? 1 : 0.5);
                  },
                ),
              ),
              RadioListTile<String>(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  AppLocalizations.of(context)!.dontAccept,
                  style: const TextStyle(color: Colors.white),
                ),
                value: 'disagree',
                groupValue: _agreementChoice,
                onChanged: (String? value) {
                  setState(() {
                    _agreementChoice = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return Colors.white.withOpacity(
                        states.contains(MaterialState.selected) ? 1 : 0.5);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: firebaseUIButton(
                  context,
                  AppLocalizations.of(context)!.ilerle,
                  _submitAgreement,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
