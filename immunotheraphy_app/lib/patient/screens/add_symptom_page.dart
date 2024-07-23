import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/screens/dosage_and_symptom_page.dart';
import 'package:immunotheraphy_app/patient/screens/infoSheets/SymptomsInfoSheet.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';

import 'infoSheets/SymptomsInfoPage.dart';

class AddSymptomsPage extends StatefulWidget {
  const AddSymptomsPage({Key? key}) : super(key: key);

  @override
  _AddSymptomsPageState createState() => _AddSymptomsPageState();
}

class _AddSymptomsPageState extends State<AddSymptomsPage>
    with SingleTickerProviderStateMixin {
  late DatabaseController _databaseController;
  late User _user;
  late DateTime _selectedDate;
  DateTime _selectedTimeCupertino = DateTime.now();
  late AnimationController _animationController;
  bool _showTime = false;
  List<String> _selectedSymptomTypes = [];
  String _symptomDetail = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    _databaseController = DatabaseController(_user.uid);
    _selectedDate = DateTime.now();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _showDatePicker() async {
    showMaterialDatePicker(
      context: context,
      title: "Semptomun görüldüğü tarih",
      selectedDate: _selectedDate,
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
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

  Future<void> _showSymptomTypePicker() async {
    List<String> allSymptomTypes = [
      AppLocalizations.of(context)!.urtiker,
      AppLocalizations.of(context)!.anjiyoOdem,
      AppLocalizations.of(context)!.kasinti,
      AppLocalizations.of(context)!.kizariklik,
      AppLocalizations.of(context)!.burunAkitmasi,
      AppLocalizations.of(context)!.hapsirik,
      AppLocalizations.of(context)!.oksuruk,
      AppLocalizations.of(context)!.hirilti,
      AppLocalizations.of(context)!.nefesDarligi,
      AppLocalizations.of(context)!.gogusAgri,
      AppLocalizations.of(context)!.karinAgri,
      AppLocalizations.of(context)!.kusma,
      AppLocalizations.of(context)!.ishal,
      AppLocalizations.of(context)!.kalbinCokHizliAtimlari,
      AppLocalizations.of(context)!.tansiyonDusmesi,
      AppLocalizations.of(context)!.bayginlikHissi,
      AppLocalizations.of(context)!.bayilma,
    ];

    await showMaterialCheckboxPicker(
      context: context,
      items: allSymptomTypes,
      headerColor: Colors.blue,
      backgroundColor: Colors.white,
      title: AppLocalizations.of(context)!.selectSymptomType,
      selectedItems: _selectedSymptomTypes,
      onChanged: (List<String> value) {
        setState(() {
          _selectedSymptomTypes = value;
        });
      },
    );
  }

  Future<void> _addSymptoms() async {
    try {
      // Constructing symptom details
      List<Map<String, dynamic>> symptoms = _selectedSymptomTypes.map((type) {
        return {
          'symptom_date': _selectedDate,
          'symptom_type': type,
          'detail': _symptomDetail,
        };
      }).toList();

      // Calling addSymptoms method from DatabaseController
      await _databaseController.addSymptoms(symptoms);

      // Show success snackbar
      _showSuccessSnackbar();
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SymptomsInfoPage()));
    } catch (e) {
      // Handle error
      print('Failed to add symptoms: $e');
      // Show error snackbar
      _showErrorSnackbar();
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Symptoms added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to add symptoms'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addSymptoms),
        surfaceTintColor: CupertinoColors.systemBackground,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.selectSymptomType,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black), // Default style
                                    children: [
                                      TextSpan(
                                        text:
                                            '${AppLocalizations.of(context)!.selected}: ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: _selectedSymptomTypes.join(", "),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // ElevatedButton(
                          //     onPressed: _showSymptomTypePicker,
                          //     style: ElevatedButton.styleFrom(
                          //         alignment: Alignment.centerLeft),
                          //     child: Text(
                          //         AppLocalizations.of(context)!.selectSymptom)
                          //     //Text(
                          //     //  '${AppLocalizations.of(context)!.selected}: ${_selectedSymptomTypes.join(", ")}'
                          //     //),
                          //     ),
                          MainElevatedButton(
                              AppLocalizations.of(context)!.selectSymptom,
                              onPressed: _showSymptomTypePicker)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.symptomTime,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 10),
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
                                            initialDateTime:
                                                _selectedTimeCupertino,
                                            onDateTimeChanged:
                                                (DateTime newDateTime) {
                                              setState(() {
                                                _selectedTimeCupertino =
                                                    newDateTime;
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
                              thickness: 0.5,
                              color: CupertinoColors.systemGrey),
                          const SizedBox(height: 10),
                          TextField(
                            maxLines: null,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.symptomDetail,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            onChanged: (value) {
                              _symptomDetail = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                              thickness: 0.5,
                              color: CupertinoColors.systemGrey),
                          const SizedBox(height: 10),
                          MainElevatedButton(
                            AppLocalizations.of(context)!.addSymptoms,
                            onPressed: () {
                              _addSymptoms();
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
