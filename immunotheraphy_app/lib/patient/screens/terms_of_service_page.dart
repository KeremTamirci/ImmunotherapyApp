import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/patient/screens/patient_home_screen.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  String? _agreementChoice;

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
            Navigator.pop(context); // Navigate back to the previous screen
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
                  // color: const Color.fromARGB(255, 100, 149, 237),
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
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white; // Color when selected
                    }
                    return Colors.white
                        .withOpacity(0.5); // Color when not selected
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
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white; // Color when selected
                    }
                    return Colors.white
                        .withOpacity(0.5); // Color when not selected
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: firebaseUIButton(
                  context,
                  AppLocalizations.of(context)!.ilerle,
                  () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientHomeScreen()),
                      (_) => false,
                    );
                  },
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
