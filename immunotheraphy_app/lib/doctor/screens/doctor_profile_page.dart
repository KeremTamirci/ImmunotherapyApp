import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/doctor/screens/doctor_signin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

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

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
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
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mm'),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
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
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.logOut),
                  onPressed: () {
                    _confirmSignOut(context);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
