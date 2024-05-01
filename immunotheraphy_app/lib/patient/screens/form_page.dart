import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';

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
        steps: [
          Step(
            title: const Text('Adım 1'),
            content: Container(
              // Content for step 1
              child: Column(
                children: [
                  // Each CheckboxListTile represents a question with a checkbox
                  CheckboxListTile(
                    title: const Text('Karnınız tok mu?'),
                    value: checkedStateStep1[0],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[0] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                        '1 saat önce antihistamin dozunuzu aldınız mı?'),
                    value: checkedStateStep1[1],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[1] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Question 3'),
                    value: checkedStateStep1[2],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[2] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Question 4'),
                    value: checkedStateStep1[3],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep1[3] = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Adım 2'),
            content: Container(
              // Content for step 1
              child: Column(
                children: [
                  // Each CheckboxListTile represents a question with a checkbox
                  CheckboxListTile(
                    title:
                        const Text('Bilmem ne ilacını almaman lazım aldın mı?'),
                    value: checkedStateStep2[0],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep2[0] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Bunu da yapmaman lazım yaptın mı?'),
                    value: checkedStateStep2[1],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep2[1] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Question 3'),
                    value: checkedStateStep2[2],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep2[2] = newValue!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Question 4'),
                    value: checkedStateStep2[3],
                    onChanged: (newValue) {
                      setState(() {
                        checkedStateStep2[3] = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Adım 3'),
            content: (_currentStep == 2 && doseAllowed)
                ? const DoseIntakePage()
                : Container(
                    child: const Center(
                    child: Text(
                      "Doz alımı yapmadan önce bütün hazırlıklarınızı tamamlamanız gerekiyor.",
                      style: TextStyle(fontSize: 24),
                    ),
                  )),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}

// class Step1Screen extends StatefulWidget {
//   const Step1Screen({super.key});

//   @override
//   State<Step1Screen> createState() => _Step1ScreenState();
// }

// class _Step1ScreenState extends State<Step1Screen> {
//   final List<bool> checkedState = [false, false, false, false];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Each CheckboxListTile represents a question with a checkbox
//         CheckboxListTile(
//           title: const Text('Karnınız tok mu?'),
//           value: checkedState[0],
//           onChanged: (newValue) {
//             setState(() {
//               checkedState[0] = newValue!;
//             });
//           },
//         ),
//         CheckboxListTile(
//           title: const Text('1 saat önce antihistamin dozunuzu aldınız mı?'),
//           value: checkedState[1],
//           onChanged: (newValue) {
//             setState(() {
//               checkedState[1] = newValue!;
//             });
//           },
//         ),
//         CheckboxListTile(
//           title: const Text('Question 3'),
//           value: checkedState[2],
//           onChanged: (newValue) {
//             setState(() {
//               checkedState[2] = newValue!;
//             });
//           },
//         ),
//         CheckboxListTile(
//           title: const Text('Question 4'),
//           value: checkedState[3],
//           onChanged: (newValue) {
//             setState(() {
//               checkedState[3] = newValue!;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
