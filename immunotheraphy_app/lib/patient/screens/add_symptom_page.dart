import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';


class AddSymptomsPage extends StatefulWidget {
  const AddSymptomsPage({Key? key}) : super(key: key);

  @override
  _AddSymptomsPageState createState() => _AddSymptomsPageState();
}

class _AddSymptomsPageState extends State<AddSymptomsPage> {
  late DatabaseController _databaseController;
  late User _user;
  late DateTime _selectedDate;
  String _selectedSymptomType = '';
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
    showMaterialScrollPicker(
      context: context,
      showDivider: false,
      title: 'Select Symptom Type',
      items: ['Fever', 'Cough', 'Headache', 'Fatigue', 'Other'],
      selectedItem: _selectedSymptomType,
      onChanged: (value) {
        setState(() {
          _selectedSymptomType = value;
        });
      },
    );
  }

  Future<void> _addSymptoms() async {
    try {
      // Constructing symptom details
      Map<String, dynamic> symptomDetails = {
        'symptom_date': _selectedDate,
        'symptom_type': _selectedSymptomType,
        'detail': _symptomDetail,
      };

      // Calling addSymptoms method from DatabaseController
      await _databaseController.addSymptoms(symptomDetails);

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
        title: Text('Add Symptoms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDatePicker,
              child: Text('Select Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            ),
            SizedBox(height: 20),
            Text(
              'Select Symptom Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showSymptomTypePicker,
              child: Text('Select Symptom Type: $_selectedSymptomType'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Symptom Detail (Optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _symptomDetail = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSymptoms,
              child: Text('Add Symptoms'),
            ),
          ],
        ),
      ),
    );
  }
}
