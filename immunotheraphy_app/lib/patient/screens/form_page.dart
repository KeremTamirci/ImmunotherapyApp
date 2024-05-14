import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
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
  final List<bool> checkedStateStep2 = [false, false, false, false];

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
        title: const Text('Doz Giriş Sayfası'),
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
                            child: const Text('Geri Dön'),
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
                            child: const Text('İlerle'),
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
            title: const Text('Adım 1'),
            content: Container(
              // Content for step 1
              child: Column(
                children: [
                  // Each CheckboxListTile represents a question with a checkbox
                  CheckboxListTile(
                    title: const Text(
                      'Karnınız tok mu?',
                      style: TextStyle(fontSize: 20),
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
                    title: const Text(
                      '1 saat önce antihistamin dozunuzu aldınız mı?',
                      style: TextStyle(fontSize: 20),
                    ),
                    value: checkedStateStep1[1],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[1] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Question 3',
                      style: TextStyle(fontSize: 20),
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
            title: const Text('Adım 2'),
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
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: CupertinoColors.systemRed,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Uyarı",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: CupertinoColors.systemRed,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Aşağıdaki bulgularda veya özel durumlarda bugünkü dozunuzu atlamanız veya 1/4'üne indirmeniz önerilir.",
                                    style: TextStyle(
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
                  title: const Text(
                    'Son birkaç saat içinde ... ilacını aldınız mı?',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: checkedStateStep2[0],
                  onChanged: (newValue) {
                    setState(() {
                      checkedStateStep2[0] = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                    'Bugün içinde ... yaptınız mı?',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: checkedStateStep2[1],
                  onChanged: (newValue) {
                    setState(() {
                      checkedStateStep2[1] = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                    'Question 3',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: checkedStateStep2[2],
                  onChanged: (newValue) {
                    setState(() {
                      checkedStateStep2[2] = newValue!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                    'Question 4',
                    style: TextStyle(fontSize: 20),
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
            title: const Text('Adım 3'),
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
    return const Center(
      child: Column(
        children: [
          Text(
            "Doz alımı yapmadan önce bütün hazırlıklarınızı tamamlamanız gerekiyor.",
            style: TextStyle(fontSize: 24),
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
    return const Center(
      child: Column(
        children: [
          Text(
            "İşaretlediğiniz bulgular sebebiyle bugünkü dozunuzu atlamanız veya 1/4'üne indirmeniz önerilir.",
            style: TextStyle(fontSize: 24),
          ),
          // SizedBox(height: 20),
        ],
      ),
    );
  }
}
