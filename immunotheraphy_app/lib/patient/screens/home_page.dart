import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedItem = 10; // Initial value for dropdown
  TimeOfDay _selectedTime = TimeOfDay.now(); // Initial value for time picker
  bool _isHospitalDosage = false; // Initial value for hospital dosage
  late DatabaseController _databaseController;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Function to show the time picker
  void _showTimePicker() {
    showMaterialTimePicker(
      context: context,
      selectedTime: _selectedTime,
      onChanged: (time) {
        setState(() {
          _selectedTime = time;
        });
      },
    );
  }

  Future<void> _showTimePickerTest() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      helpText: "Dozu Aldığınız Zamanı Seçiniz",
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

  // Function to save dosage information to Firestore
  void _saveDosageInfo() async {
    try {
      Map<String, dynamic> dosageDetails = {
        'dosage_date': DateTime.now(),
        'detail': 'Doz kaydı detayı',
        'dosage_amount': _selectedItem, // Using the selected item directly
        'is_hospital_dosage': _isHospitalDosage,
        'measure_metric': 'mg',
        // Add any other fields you need for your dosage recording
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
      const SnackBar(
        content: Text('Dosage recording added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Select Dosage:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: 350,
            decoration: BoxDecoration(
              color: hexStringToColor("E8EDF2"),
              borderRadius: BorderRadius.circular(40),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedItem,
                isExpanded: true,
                dropdownColor: hexStringToColor("E8EDF2"),
                iconSize: 36,
                style: TextStyle(
                  color: hexStringToColor("4F7396"),
                  fontSize: 18,
                ),
                borderRadius: BorderRadius.circular(30),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                  });
                },
                items: <int>[10, 20, 30, 40, 50]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('$value'), // Convert integer to string
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // onPressed: _showTimePicker, // ESKİ HALİ BU
            onPressed: _showTimePickerTest,
            child: const Text('Select Time'),
          ),
          const SizedBox(height: 20),
          Text(
            'Selected Time: ${_selectedTime.hour}:${_selectedTime.minute}',
            style: const TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hospital Dosage:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 5),
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
          ElevatedButton(
            onPressed: _saveDosageInfo,
            child: const Text('Save Dosage Info'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
