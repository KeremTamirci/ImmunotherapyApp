import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddSymptomsPage extends StatefulWidget {
  const AddSymptomsPage({Key? key}) : super(key: key);

  @override
  _AddSymptomsPageState createState() => _AddSymptomsPageState();
}

class _AddSymptomsPageState extends State<AddSymptomsPage> {
  late DatabaseController _databaseController;
  late User _user;
  late DateTime _selectedDate;
  List<String> _selectedSymptomTypes = [];
  String _symptomDetail = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    _databaseController = DatabaseController(_user.uid);
    _selectedDate = DateTime.now();
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
        title:  Text(AppLocalizations.of(context)!.addSymptoms),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDatePicker,
              child: Text('Select Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.selectSymptomType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showSymptomTypePicker,
            child: Text(
              '${AppLocalizations.of(context)!.selected}: ${_selectedSymptomTypes.join(", ")}'
            ),

            ),
            const SizedBox(height: 20),
            TextField(
              decoration:  InputDecoration(
                labelText: AppLocalizations.of(context)!.symptomDetail,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _symptomDetail = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSymptoms,
              child:  Text(AppLocalizations.of(context)!.addSymptoms),
            ),
          ],
        ),
      ),
    );
  }
}
