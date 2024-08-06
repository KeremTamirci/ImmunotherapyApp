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

import '../../doctor/utils/firebase_initialization.dart';

class DoseIntakePage extends StatefulWidget {
  final bool warning;
  const DoseIntakePage({super.key, required this.warning});

  @override
  State<DoseIntakePage> createState() => DoseIntakePageState();
}

class DoseIntakePageState extends State<DoseIntakePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedTimeCupertino = DateTime.now();
  bool _showTime = false;
  bool _isHospitalDosage = false;
  String _selectedWatering = '';

  late DatabaseController _databaseController;
  late User _user;

  String _allergyType = '';
  String _dosageUnit = 'mg'; // Default unit

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _getUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _databaseController = DatabaseController(user.uid);
      });
      await _fetchPatientData();
    }
  }

  Future<void> _fetchPatientData() async {
    try {
      Patient patient = await _databaseController.getPatientData();
      setState(() {
        //_allergyType = patient.allergyType; // Adjust based on your field name
        _allergyType = patient.allergyType;
        _updateDosageUnit();
      });
    } catch (e) {
      print('Failed to fetch patient data: $e');
    }
  }

  void _updateDosageUnit() {
    if (_allergyType == 'Milk' || _allergyType == 'Sesame') {
      _dosageUnit = 'ml';
    } else {
      _dosageUnit = 'mg';
    }
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

  Future<void> _showTimePickerTest() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      helpText: AppLocalizations.of(context)!.dosageTimeSelect,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => ListView(reverse: true, children: [
        Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
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

  void _saveDosageInfo() async {
    try {
      Map<String, dynamic> dosageDetails = {
        'dosage_date': _selectedTimeCupertino,
        'detail': 'Doz kaydı detayı',
        'dosage_amount': double.tryParse(_textController.text),
        'is_hospital_dosage': _isHospitalDosage,
        'measure_metric': _dosageUnit,
      };

      if (_selectedWatering.isNotEmpty) {
        dosageDetails['watering'] = _selectedWatering;
      }

      await _databaseController.addDosageTime(dosageDetails);
      _showSuccessSnackbar();
    } catch (e) {
      print('Failed to save dosage information: $e');
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.dosageAdded),
        duration: const Duration(seconds: 4),
      ),
    );
    Navigator.pop(context, true);
  }

  Future<void> _checkValue(double minValue, double maxValue) async {
    double? value = double.tryParse(_textController.text);
    if (value == null) {
      _showRangeAlert();
    } else if (value < minValue || value > maxValue) {
      _showRangeAlert();
    } else {
      _saveDosageInfo();
    }
  }

  void _showActionSheet(BuildContext context) {
    if (_allergyType == 'Egg' ||
        _allergyType == 'Sesame' ||
        _allergyType == 'Milk') {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.watering),
          message: Text(AppLocalizations.of(context)!.ratioOfWater),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedWatering = '1/1';
                });
              },
              child: const Text('1/1'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _selectedWatering = '1/10';
                });
                Navigator.pop(context);
              },
              child: const Text('1/10'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _selectedWatering = '1/100';
                });
                Navigator.pop(context);
              },
              child: const Text('1/100'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
/*            height: (_allergyType == 'Egg' ||
                    _allergyType == 'Sesame' ||
                    _allergyType == 'Milk')
                ? 155
                : 83, */
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  if (_allergyType == 'Egg' ||
                      _allergyType == 'Sesame' ||
                      _allergyType == 'Milk')
                    SizedBox(
                      width: 350,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.watering,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_allergyType == 'Egg' ||
                      _allergyType == 'Sesame' ||
                      _allergyType == 'Milk')
                    const Divider(
                        thickness: 0.5, color: CupertinoColors.systemGrey),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.dosageAmount +
                          ' ($_dosageUnit)',
                      hintStyle:
                          const TextStyle(color: CupertinoColors.systemGrey),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: CupertinoColors.systemBackground,
                    ),
                    style: TextStyle(
                      color: hexStringToColor("4F7396"),
                      fontSize: 16,
                    ),
                    controller: _textController,
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
          Container(
            decoration: const BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dosageTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                      //const SizedBox(width: 10),
                      const Spacer(),
                      CupertinoButton(
                        onPressed: _toggleDatePickerVisibility,
                        child: Text(
                          '${_selectedTimeCupertino.hour}:${(_selectedTimeCupertino.minute < 10) ? "0" : ""}${_selectedTimeCupertino.minute}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
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
                    //width: 350,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.hospitalDosage,
                          style: const TextStyle(fontSize: 16),
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
                  const SizedBox(height: 10),
                  MainElevatedButton(
                    AppLocalizations.of(context)!.saveDosage,
                    onPressed: () {
                      _checkValue(0, 200);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
