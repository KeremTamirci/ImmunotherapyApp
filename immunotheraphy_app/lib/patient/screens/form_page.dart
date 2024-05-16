import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:immunotheraphy_app/utils/color_utils.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  int _currentStep = 0;
  bool doseAllowed = false;
  final List<bool> checkedStateStep1 = [false, false, false, false];
  final List<bool> checkedStateStep2 = [false, false, false, false, false];

  bool areAllCheckedStep1() {
    return checkedStateStep1.every((element) => element == true);
  }

  bool areAllCheckedStep2() {
    return checkedStateStep2.every((element) => element == false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.dozGirisSayfasi),
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
                    (_currentStep != 0)
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
                            child:  Text(AppLocalizations.of(context)!.geriDon),
                          )
                        : Container(),
                    (_currentStep != 2)
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
                            child:  Text(AppLocalizations.of(context)!.ilerle),
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
            title:  Text(AppLocalizations.of(context)!.adim1),
            content: Container(
              // Content for step 1
              child: Column(
                children: [
                  // Each CheckboxListTile represents a question with a checkbox
                  CheckboxListTile(
                    title:  Text(
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
                    title:  Text(
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
                  CheckboxListTile(
                    title:  Text(
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
                  CheckboxListTile(
                    title: const Text(
                      'Question 4',
                      style: TextStyle(fontSize: 20),
                    ),
                    value: checkedStateStep1[3],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[3] = newValue!;
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
            title:  Text(AppLocalizations.of(context)!.adim2),
            content: Column(
              children: [
                !areAllCheckedStep2()
                    ? Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: CupertinoColors.systemBackground),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.warning,
                                        color: CupertinoColors.systemRed,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations.of(context)!.uyari,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            color: CupertinoColors.systemRed,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                   Text(
                                    AppLocalizations.of(context)!.bulgulardaOneri,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // color: CupertinoColors.systemRed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      )
                    : Container(),
                // const Divider(),
                // Each CheckboxListTile represents a question with a checkbox
                CheckboxListTile(
                  title:  Text(
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
                  title:  Text(
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
                  title:  Text(
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
                  title:  Text(
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
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title:  Text(AppLocalizations.of(context)!.adim3),
            content: (_currentStep == 2 && doseAllowed)
                ? const DoseIntakePage()
                : (!areAllCheckedStep1())
                    ? const Step1Incomplete()
                    : const Step1Incomplete(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
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
    return  Center(
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
