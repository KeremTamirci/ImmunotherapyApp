import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/patient/screens/form_page.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/reusable_widgets/warning_box.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

class DoseIntakePage extends StatefulWidget {
  final bool warning;
  const DoseIntakePage({super.key, required this.warning});

  @override
  State<DoseIntakePage> createState() => DoseIntakePageState();
}

class DoseIntakePageState extends State<DoseIntakePage>
    with SingleTickerProviderStateMixin {
  // int _selectedItem = 10; // Initial value for dropdown
  // String _numericValue = '';
  final TextEditingController _textController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now(); // Initial value for time picker
  DateTime _selectedTimeCupertino = DateTime.now();
  bool _showTime = false;
  bool _isHospitalDosage = false; // Initial value for hospital dosage
  String _selectedWatering = '1/1';
  final List<String> _wateringValues = ['1/1', '1/10', '1/100'];

  late DatabaseController _databaseController;
  // ignore: unused_field
  late User _user;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _getUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDatePickerVisibility() {
    if (_showTime) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _showTime = !_showTime;
    });
  }

  // // Function to show the time picker
  // void _showTimePicker() {
  //   showMaterialTimePicker(
  //     context: context,
  //     selectedTime: _selectedTime,
  //     onChanged: (time) {
  //       setState(() {
  //         _selectedTime = time;
  //       });
  //     },
  //   );
  // }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => ListView(reverse: true, children: [
        Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
        CupertinoButton(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(
                  color: CupertinoColors.activeBlue, fontSize: 22),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ]),
    );
  }

  Future<void> _showTimePickerTest() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      helpText: AppLocalizations.of(context)!.dosageTimeSelect,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        // We just wrap these environmental changes around the
        // child in this builder so that we can apply the
        // options selected above. In regular usage, this is
        // rarely necessary, because the default values are
        // usually used as-is.
        return Theme(
          data: Theme.of(context),
          // .copyWith(
          //   textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 36)),
          // )
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          ),
        );
      },
    );
    setState(() {
      _selectedTime = pickedTime!;
    });
  }

  void _showRangeAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: CupertinoColors.systemBackground,
          title: DialogTitleText(AppLocalizations.of(context)!.incorrectDosage,
              color: const Color.fromARGB(255, 126, 6, 0)),
          content:
              DialogText(AppLocalizations.of(context)!.incorrectDosageExpl),
          actions: <Widget>[
            DialogTextButton(
              "OK",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to save dosage information to Firestore
  void _saveDosageInfo() async {
    try {
      Map<String, dynamic> dosageDetails = {
        'dosage_date': _selectedTimeCupertino,
        'detail': 'Doz kaydı detayı',
        'dosage_amount': double.tryParse(_textController.text),
        'is_hospital_dosage': _isHospitalDosage,
        'measure_metric': 'ml',
        'watering': _selectedWatering,
      };

      await _databaseController.addDosageTime(dosageDetails);
      _showSuccessSnackbar();
    } catch (e) {
      print('Failed to save dosage information: $e');
      // Handle error
    }
  }

  // Function to show a snackbar indicating success
  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.dosageAdded),
        duration: const Duration(seconds: 4),
      ),
    );
    Navigator.pop(context, true);
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

  Future<void> _checkValue(double minValue, double maxValue) async {
    double? value = double.tryParse(_textController.text);
    if (value == null) {
      _showRangeAlert();
    } else if (value < minValue || value > maxValue) {
      // If the value is bigger than 200, show an alert dialog
      _showRangeAlert();
    } else {
      _saveDosageInfo();
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.watering),
        message: Text(AppLocalizations.of(context)!.ratioOfWater),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            onPressed: () {
              Navigator.pop(context);
              _selectedWatering = '1/1';
            },
            child: const Text('1/1'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _selectedWatering = '1/10';
              Navigator.pop(context);
            },
            child: const Text('1/10'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _selectedWatering = '1/100';
            },
            child: const Text('1/100'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // appBar: AppBar(),
    // body:
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (widget.warning) ? const WarningBox() : Container(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              AppLocalizations.of(context)!.dosageAmount,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            // width: 350,
            height: 155,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 350,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sulandırma",
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        CupertinoButton(
                            onPressed: () => _showActionSheet(context),
                            child: Text(
                              _selectedWatering,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Divider(
                      thickness: 0.5, color: CupertinoColors.systemGrey),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.dosageAmountMl,
                      hintStyle:
                          const TextStyle(color: CupertinoColors.systemGrey),
                      // alignLabelWithHint: true,
                      // labelText: 'Doz miktarını giriniz',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none),
                      filled: true,
                      // fillColor: hexStringToColor("E8EDF2"),
                      fillColor: CupertinoColors.systemBackground,
                    ),
                    style: TextStyle(
                      color: hexStringToColor("4F7396"),
                      fontSize: 18,
                    ),
                    // Set the TextEditingController
                    controller: _textController,
                    // Inside the onChanged callback
                    onChanged: (String value) {
                      // Parse the input value to ensure it's numeric
                      String newValue =
                          value.replaceAll(RegExp(r'[^0-9.]'), '');

                      // Update the text field's value without triggering onChanged
                      _textController.value = _textController.value.copyWith(
                        text: newValue,
                        selection:
                            TextSelection.collapsed(offset: newValue.length),
                        composing: TextRange.empty,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ElevatedButton(
          //   // onPressed: _showTimePicker, // ESKİ HALİ BU
          //   // onPressed: _showTimePickerTest,
          //   onPressed: _showCupertinoTimePicker,
          //   child: const Text('Select Time'),
          // ),
          Container(
            decoration: const BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dosageTime,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      // SizedBox(
                      //   width: 100,
                      //   child:
                      const Spacer(),
                      CupertinoButton(
                        // padding: const EdgeInsets.all(0),
                        // color: CupertinoColors.systemGrey,
                        // Display a CupertinoDatePicker in time picker mode.
                        // onPressed: () => _showDialog(
                        //   CupertinoDatePicker(
                        //     initialDateTime: _selectedTimeCupertino,
                        //     mode: CupertinoDatePickerMode.time,
                        //     use24hFormat: true,
                        //     // This is called when the user changes the time.
                        //     onDateTimeChanged: (DateTime newTime) {
                        //       setState(() => _selectedTimeCupertino = newTime);
                        //     },
                        //   ),
                        // ),
                        onPressed: _toggleDatePickerVisibility,
                        child: Text(
                          '${_selectedTimeCupertino.hour}:${(_selectedTimeCupertino.minute < 10) ? "0" : ""}${_selectedTimeCupertino.minute}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      // ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      // height: _showTime ? 232 : 0,
                      child: _showTime
                          ? Column(
                              children: [
                                const Divider(
                                    thickness: 0.5,
                                    color: CupertinoColors.systemGrey),
                                SizedBox(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    use24hFormat: true,
                                    initialDateTime: _selectedTimeCupertino,
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      setState(() {
                                        _selectedTimeCupertino = newDateTime;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const Divider(
                      thickness: 0.5, color: CupertinoColors.systemGrey),
                  SizedBox(
                    width: 350,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.hospitalDosage,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Spacer(),
                        Checkbox(
                          value: _isHospitalDosage,
                          onChanged: (newValue) {
                            setState(() {
                              _isHospitalDosage = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      thickness: 0.5, color: CupertinoColors.systemGrey),
                  const SizedBox(height: 20),
                  MainElevatedButton(
                    AppLocalizations.of(context)!.saveDosage,
                    onPressed: () {
                      _checkValue(0, 200);
                      // Navigator.pop(context);
                    },
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _checkValue(0, 200);
                  //     // Navigator.pop(context);
                  //   },
                  //   // Navigator.pop(context); // Bunu çalıştırınca database'e eklemiyor.
                  //   child: Text(
                  //     AppLocalizations.of(context)!.saveDosage,
                  //     style: const TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // // Uncomment for apple style button
          // const SizedBox(height: 20),
          // Center(
          //   child: Container(
          //     width: double.infinity,
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          //     child: CupertinoButton(
          //         color: CupertinoColors.systemBackground,
          //         onPressed: () {
          //           _checkValue(0, 200);
          //         },
          //         child: const Text(
          //           "Save Dosage Info",
          //           style: TextStyle(color: CupertinoColors.activeBlue),
          //         )),
          //   ),
          // ),
        ],
      ),
    );
    // );
  }
}
