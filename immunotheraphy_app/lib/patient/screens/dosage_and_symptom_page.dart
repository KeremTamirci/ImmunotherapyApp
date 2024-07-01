import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/patient/screens/add_symptom_page.dart';
// import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:immunotheraphy_app/patient/screens/form_page.dart';
import 'package:immunotheraphy_app/patient/screens/infoSheets/AllergyInfoSheet.dart';
import 'package:immunotheraphy_app/patient/screens/infoSheets/MilkLadderInfoSheet.dart';
import 'package:immunotheraphy_app/patient/screens/infoSheets/SymptomsInfoSheet.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DosageAndSymptomPage extends StatefulWidget {
  const DosageAndSymptomPage({super.key});

  @override
  State<DosageAndSymptomPage> createState() => _DosageAndSymptomPageState();
}

class _DosageAndSymptomPageState extends State<DosageAndSymptomPage> {
  late DatabaseController _databaseController;
  late User _user;
  bool? _hasTakenDose;
  bool? _incorrectTime = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _checkDosage();
    _checkTime();
  }

  Future<void> _checkDosage() async {
    bool hasTakenDose = await hasTakenDosage();
    setState(() {
      _hasTakenDose = hasTakenDose;
      _isLoading = false;
    });
  }

  Future<void> _checkTime() async {
    bool incorrectTime = await checkTime();
    setState(() {
      _incorrectTime = incorrectTime;
      _isLoading = false;
    });
  }

  Future<bool> hasTakenDosage() async {
    bool isLastDoseToday = await _databaseController.isLastDoseToday();
    if (isLastDoseToday) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkTime() async {
    bool isAfterSeven = await _databaseController.isAfterSeven();
    if (isAfterSeven) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _databaseController = DatabaseController(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          //forceMaterialTransparency: true,
          title: Text(AppLocalizations.of(context)!.dosageAndSymptomPage),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (_hasTakenDose == true)
                          InformationBox(
                            title: "You have entered your dose for today!",
                            onTap: () {
                              print("Box 1 alternative version tapped");
                            },
                            icon: Icons.task_alt,
                            linearGradient: LinearGradient(
                              colors: [
                                // hexStringToColor("3DED97"),
                                // hexStringToColor("18C872")
                                hexStringToColor("0F7A50"),
                                hexStringToColor("065E44"),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            isButtonActive: false,
                          )
                        // else if (_incorrectTime == false)
                        //   InformationBox(
                        //     title:
                        //         "It is past 19.00, you cannot take your dose today!",
                        //     onTap: () {
                        //       print("Box 1 other alternative version tapped");
                        //     },
                        //     icon: Icons.block,
                        //     linearGradient: LinearGradient(
                        //       colors: [
                        //         hexStringToColor("FFA500"), // Lighter orange
                        //         hexStringToColor("CC8400"), // Darker orange
                        //       ],
                        //       begin: Alignment.topCenter,
                        //       end: Alignment.bottomCenter,
                        //     ),
                        //     isButtonActive: false,
                        //   )
                        else
                          InformationBox(
                              title: AppLocalizations.of(context)!.dosageEntry,
                              onTap: () {
                                print('Box 1 tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FormPage(isAfterSeven: _incorrectTime),
                                  ),
                                );
                              },
                              icon: Icons.list,
                              linearGradient: (_incorrectTime == false)
                                  ? LinearGradient(
                                      colors: [
                                        hexStringToColor("3DED97"),
                                        hexStringToColor("18C872")
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        hexStringToColor(
                                            "FFA500"), // Lighter orange
                                        hexStringToColor(
                                            "CC8400"), // Darker orange
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )),
                        InformationBox(
                          title: AppLocalizations.of(context)!.symptomEntry,
                          onTap: () {
                            print('Box 2 tapped');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddSymptomsPage(),
                              ),
                            );
                          },
                          icon: Icons.sick,
                          linearGradient: LinearGradient(
                            colors: [
                              hexStringToColor("3FA5FF"),
                              hexStringToColor("1A80E5")
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        AppLocalizations.of(context)!.informationalEntries,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InfoCardWidget(
                            title: AppLocalizations.of(context)!.aboutSymptoms,
                            description: AppLocalizations.of(context)!.whatToDo,
                            imagePath: "assets/images/kalp_atisi.png",
                            cardNo: 0,
                          ),
                          InfoCardWidget(
                            title: AppLocalizations.of(context)!.milkLadder,
                            description: AppLocalizations.of(context)!
                                .milkLadderSubtitle,
                            imagePath: "assets/images/sut_ana_resim.png",
                            cardNo: 1,
                          ),
                          InfoCardWidget(
                            title: 'Alerjik Besinler',
                            description: "Yaygın besin alerjileri",
                            imagePath: "assets/images/armut_yiyen_adam.png",
                            cardNo: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  int getPatientDoseNumber() {
    return 3;
  }
}

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final int cardNo;
  const InfoCardWidget(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.description,
      required this.cardNo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        // shadowColor: Color.fromARGB(255, 255, 14, 14),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
          onTap: () {
            debugPrint('Card $title tapped.');
            showModalBottomSheet(
                backgroundColor: CupertinoColors.systemBackground,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) {
                  switch (cardNo) {
                    case 0:
                      return SymptomsInfoSheet();
                    case 1:
                      return MilkLadderInfoSheet();
                    case 2:
                      return AllergyInfoSheet();
                    default:
                      return Container(); // Return some default widget if cardNo doesn't match any case.
                  }
                });
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ), // Replace YourImageWidget with your image widget
                ),
                Expanded(
                  flex: description.length > 50 ? 5 : 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InformationBox extends StatelessWidget {
  final String title;
  final IconData icon;
  // final Color color;
  final LinearGradient linearGradient;
  final void Function()? onTap;
  final bool isButtonActive;

  const InformationBox({
    super.key,
    required this.title,
    required this.icon,
    // required this.color,
    required this.onTap,
    required this.linearGradient,
    this.isButtonActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.44,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          gradient: linearGradient,
          // color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 20),
              Icon(
                icon,
                size: MediaQuery.of(context).size.height * 0.08,
                color: Colors.white,
              ),
              // const SizedBox(height: 15),
              const Spacer(),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.35, // Set a maximum width for the text
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center, // Center the text horizontally
                    softWrap: true, // Enable text wrapping
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 15),
              const Spacer(),
              isButtonActive
                  ? ElevatedButton(
                      onPressed: null,
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.start,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : Container()
              // const Text(
              //   "Başla",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
