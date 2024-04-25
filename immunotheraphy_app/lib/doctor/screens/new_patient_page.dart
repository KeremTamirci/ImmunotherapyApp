import 'dart:math';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:immunotheraphy_app/doctor/screens/otp_page_screen.dart';

class NewPatientPage extends StatefulWidget {
  const NewPatientPage({Key? key}) : super(key: key);

  @override
  State<NewPatientPage> createState() => _NewPatientPageState();
}

class _NewPatientPageState extends State<NewPatientPage> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _surnameTextController = TextEditingController();
  TextEditingController _allergyTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();

  String? _selectedAllergy;
  List<String> _allergies = ['Milk', 'Nuts'];

  bool _hasAllergicRhinitis = false;
  bool _hasAsthma = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('Patients');

  DateTime? _selectedDateOfBirth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Patient'),
        backgroundColor: hexStringToColor("6495ED"),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _blueTextField(
                  "Name",
                  Icons.person_outline,
                  _nameTextController,
                ),
                const SizedBox(height: 20),
                _blueTextField(
                  "Surname",
                  Icons.person_outline,
                  _surnameTextController,
                ),
                const SizedBox(height: 20),
                _allergyDropdown(),
                const SizedBox(height: 20),
                _blueTextField(
                  "Phone Number",
                  Icons.phone,
                  _phoneNumberTextController,
                ),
                const SizedBox(height: 20),
                _dateOfBirthField(context),
                const SizedBox(height: 20),
                Row(
                  children: [
                    FancyCheckbox(
                      value: _hasAllergicRhinitis,
                      onChanged: (value) {
                        setState(() {
                          _hasAllergicRhinitis = value!;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Text('Has Allergic Rhinitis'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    FancyCheckbox(
                      value: _hasAsthma,
                      onChanged: (value) {
                        setState(() {
                          _hasAsthma = value!;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Text('Has Asthma'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _registerPatient();
                  },
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hexStringToColor("6495ED"),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _blueTextField(
    String hintText,
    IconData icon,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: hexStringToColor("6495ED").withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: hexStringToColor("6495ED")),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hexStringToColor("6495ED")),
          prefixIcon: Icon(
            icon,
            color: hexStringToColor("6495ED"),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _allergyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: hexStringToColor("6495ED").withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          hintText: 'Allergy Type',
          hintStyle: TextStyle(color: hexStringToColor("6495ED")),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.info_outline,
            color: hexStringToColor("6495ED"),
          ),
        ),
        value: _selectedAllergy,
        items: _allergies.map((allergy) {
          return DropdownMenuItem(
            child: Text(allergy),
            value: allergy,
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedAllergy = newValue as String?;
          });
        },
      ),
    );
  }

  Widget _dateOfBirthField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexStringToColor("6495ED").withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _dateOfBirthController,
        style: TextStyle(color: hexStringToColor("6495ED")),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        decoration: InputDecoration(
          hintText: 'Date of Birth',
          hintStyle: TextStyle(color: hexStringToColor("6495ED")),
          prefixIcon: Icon(
            Icons.calendar_today,
            color: hexStringToColor("6495ED"),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _selectedDateOfBirth = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

void _registerPatient() async {
  final currentUser = _auth.currentUser;
  if (currentUser != null) {
    if (_nameTextController.text.isEmpty ||
        _surnameTextController.text.isEmpty ||
        _phoneNumberTextController.text.isEmpty ||
        _selectedDateOfBirth == null ||
        _selectedAllergy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
    } else {
      try {
        String otp = _generateOTP();
        await PatientsFirestoreService().addPatient(
          _nameTextController.text,
          _surnameTextController.text,
          _phoneNumberTextController.text,
          _selectedDateOfBirth!,
          _hasAllergicRhinitis,
          _hasAsthma,
          currentUser.uid,
          otp,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(otp: otp),
          ),
        );
      } catch (e) {
        print('Error registering patient: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register patient. Please try again later.'),
          ),
        );
      }
    }
  } else {
    print('User not logged in');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not logged in. Please log in and try again.'),
      ),
    );
  }
}



  String _generateOTP() {
    const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random(DateTime.now().millisecondsSinceEpoch);
    return String.fromCharCodes(Iterable.generate(
      7,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ));
  }
}

class FancyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const FancyCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue),
      ),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          checkColor: Colors.white,
        ),
      ),
    );
  }
}