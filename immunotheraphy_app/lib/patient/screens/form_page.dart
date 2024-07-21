import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/reusable_widgets/warning_box.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
// import 'package:immunotheraphy_app/utils/color_utils.dart';

class FormPage extends StatefulWidget {
  final bool? isAfterSeven;
  final bool? hasAsthma;
  const FormPage(
      {super.key, required this.isAfterSeven, required this.hasAsthma});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  bool _dialogShown = false;
  int _currentStep = 0;
  bool doseAllowed = false;
  List<bool> checkedStateStep1 = [false, false, false];
  final List<bool> checkedStateStep2 = [false, false, false, false, false];

  bool areAllCheckedStep1() {
    return checkedStateStep1.every((element) => element == true);
  }

  bool areAllCheckedStep2() {
    return checkedStateStep2.every((element) => element == false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAfterSeven != null &&
        widget.isAfterSeven == true &&
        !_dialogShown) {
      _dialogShown = true;
      Future.delayed(Duration.zero, () => _showEnhancedAlertDialog(context));
    }

    if (!widget.hasAsthma!) {
      setState(() {
        checkedStateStep1[2] = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dozGirisSayfasi),
        surfaceTintColor: CupertinoColors.systemBackground,
      ),
      body: Stepper(
        // connectorColor: const MaterialStatePropertyAll(Color(0xff18c872)),
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < 2) {
              _currentStep += 1;
            }
            if (_currentStep == 2) {
              if (areAllCheckedStep1() && areAllCheckedStep2()) {
                doseAllowed = true;
              } else {
                doseAllowed = false;
              }
            } else {
              // Finish or submit action
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            } else {
              _currentStep = 0;
            }
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return (_currentStep == 2 && doseAllowed)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    (_currentStep != 0 && _currentStep <= 2)
                        ? TextButton(
                            onPressed: details.onStepCancel,
                            style: const ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                  TextStyle(fontSize: 18)),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(70, 50)),
                              foregroundColor: MaterialStatePropertyAll(
                                Color(0xff1a80e5),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.geriDon),
                          )
                        : Container(),
                    (_currentStep == 0 ||
                            (_currentStep == 1 && areAllCheckedStep1()))
                        ? ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: const ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                    TextStyle(fontSize: 18)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Color(0xff1a80e5)),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(70, 50))),
                            child: Text(AppLocalizations.of(context)!.ilerle),
                          )
                        : Container(),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                );
        },
        steps: [
          Step(
            title: Text(AppLocalizations.of(context)!.adim1),
            content: Container(
              // Content for step 1
              child: Column(
                children: [
                  // Each CheckboxListTile represents a question with a checkbox
                  CheckboxListTile(
                    title: Text(
                      AppLocalizations.of(context)!.karninizTokMu,
                      style: const TextStyle(fontSize: 20),
                    ),
                    // activeColor: Colors.blue,
                    value: checkedStateStep1[0],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[0] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      AppLocalizations.of(context)!.antihistaminDozu,
                      style: const TextStyle(fontSize: 20),
                    ),
                    value: checkedStateStep1[1],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[1] = newValue!;
                      });
                    },
                  ),
                  if (widget.hasAsthma!)
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context)!.astimIlaci,
                        style: const TextStyle(fontSize: 20),
                      ),
                      value: checkedStateStep1[2],
                      onChanged: (newValue) {
                        setState(() {
                          checkedStateStep1[2] = newValue!;
                        });
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.adim2),
            content: areAllCheckedStep1()
                ? Column(
                    children: [
                      !areAllCheckedStep2() ? const WarningBox() : Container(),
                      // const Divider(),
                      // Each CheckboxListTile represents a question with a checkbox
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)!.yolculuktaMisiniz,
                          style: const TextStyle(fontSize: 20),
                        ),
                        value: checkedStateStep2[0],
                        onChanged: (newValue) {
                          setState(() {
                            checkedStateStep2[0] = newValue!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)!.agirEgzersiz,
                          style: const TextStyle(fontSize: 20),
                        ),
                        value: checkedStateStep2[1],
                        onChanged: (newValue) {
                          setState(() {
                            checkedStateStep2[1] = newValue!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)!.yorgunHissediyor,
                          style: const TextStyle(fontSize: 20),
                        ),
                        value: checkedStateStep2[2],
                        onChanged: (newValue) {
                          setState(() {
                            checkedStateStep2[2] = newValue!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)!.vucutSicakligi,
                          style: const TextStyle(fontSize: 20),
                        ),
                        value: checkedStateStep2[3],
                        onChanged: (newValue) {
                          setState(() {
                            checkedStateStep2[3] = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : const Step1Incomplete(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.adim3),
            content: (_currentStep == 2 && areAllCheckedStep2())
                ? const DoseIntakePage(warning: false)
                : const DoseIntakePage(warning: true),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}

void _showEnhancedAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.info, color: Color.fromARGB(255, 126, 6, 0)),
            const SizedBox(width: 10),
            DialogTitleText(AppLocalizations.of(context)!.importantNotice,
                color: const Color.fromARGB(255, 126, 6, 0)),
            // Text(
            //   'Important Notice',
            //   style: TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(255, 126, 6, 0),
            //   ),
            // ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              DialogText(AppLocalizations.of(context)!.importantNotice1),
              // Text(
              //   'It is currently past 19:00.',
              //   style: TextStyle(fontSize: 20, color: Colors.black87),
              // ),
              const SizedBox(height: 10),
              DialogText((AppLocalizations.of(context)!.importantNotice2))
              // Text(
              //   'It is not recommended to take the dose after 19:00. You can consider skipping today\'s dose.',
              //   style: TextStyle(fontSize: 20, color: Colors.black87),
              // ),
            ],
          ),
        ),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pop();
          //   },
          //   style: const ButtonStyle(
          //     textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 18)),
          //     minimumSize: MaterialStatePropertyAll(Size(70, 50)),
          //     foregroundColor: MaterialStatePropertyAll(
          //       Color.fromARGB(255, 126, 6, 0),
          //     ),
          //   ),
          //   child: Text(AppLocalizations.of(context)!.geriDon),
          // ),
          DialogTextButton(
            AppLocalizations.of(context)!.geriDon,
            textColor: const Color.fromARGB(255, 126, 6, 0),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   style: const ButtonStyle(
          //       textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 18)),
          //       backgroundColor:
          //           MaterialStatePropertyAll(Color.fromARGB(255, 126, 6, 0)),
          //       foregroundColor: MaterialStatePropertyAll(Colors.white),
          //       minimumSize: MaterialStatePropertyAll(Size(70, 50))),
          //   child: Text(AppLocalizations.of(context)!.ilerle),
          // ),
          DialogElevatedButton(
            AppLocalizations.of(context)!.ilerle,
            backgroundColor: const Color.fromARGB(255, 126, 6, 0),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

class Step1Incomplete extends StatelessWidget {
  const Step1Incomplete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.dozAlimTamamlama,
            style: const TextStyle(fontSize: 24),
          ),
          // SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Step2Incomplete extends StatelessWidget {
  const Step2Incomplete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.bulgularOneri,
            style: const TextStyle(fontSize: 24),
          ),
          // SizedBox(height: 20),
        ],
      ),
    );
  }
}
