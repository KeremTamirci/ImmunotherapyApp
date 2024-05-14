import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

class DoseIntakePage extends StatefulWidget {
  const DoseIntakePage({super.key});

  @override
  State<DoseIntakePage> createState() => DoseIntakePageState();
}

class DoseIntakePageState extends State<DoseIntakePage> {
  int _selectedItem = 10; // Initial value for dropdown
  String _numericValue = '';
  final TextEditingController _textController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now(); // Initial value for time picker
  bool _isHospitalDosage = false; // Initial value for hospital dosage
  late DatabaseController _databaseController;
  // ignore: unused_field
  late User _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
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

  void _showRangeAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dosage Value Too Big"),
          content: const Text("The dosage value is too big."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
        'dosage_date': DateTime.now(),
        'detail': 'Doz kaydı detayı',
        // 'dosage_amount': _selectedItem, // Using the selected item directly
        'dosage_amount': int.tryParse(_textController.text),
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

  Future<void> _checkValue() async {
    int? value = int.tryParse(_textController.text);
    print("AAAAAAAAAAAAAAAAAAAAAAAA");
    print("Text Controller Value: ${_textController.text}");
    if (value == null) {
      _showRangeAlert();
    } else if (value > 200) {
      // If the value is bigger than 200, show an alert dialog
      _showRangeAlert();
    } else {
      _saveDosageInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // appBar: AppBar(),
    // body:
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              hintText: 'Enter a number',
              labelText: 'Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: hexStringToColor("E8EDF2"),
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
              String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');

              // Update the text field's value without triggering onChanged
              _textController.value = _textController.value.copyWith(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
                composing: TextRange.empty,
              );
            },
          ),
          // MyDropdownWidget(
          //   selectedItem: _selectedItem,
          //   onChanged: (int? newValue) {
          //     setState(() {
          //       _selectedItem = newValue!;
          //     });
          //   },
          // ),
        ),
        const SizedBox(height: 20),
        Text(
          'Selected Time: ${_selectedTime.hour}:${_selectedTime.minute}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          // onPressed: _showTimePicker, // ESKİ HALİ BU
          onPressed: _showTimePickerTest,
          child: const Text('Select Time'),
        ),
        SizedBox(
          width: 350,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
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
          onPressed: _checkValue,
          // Navigator.pop(context); // Bunu çalıştırınca database'e eklemiyor.
          child: const Text('Save Dosage Info'),
        ),
        const SizedBox(height: 20),
      ],
    );
    // );
  }
}

class MyDropdownWidget extends StatelessWidget {
  final int selectedItem;
  final ValueChanged<int?> onChanged;

  const MyDropdownWidget({
    super.key,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: selectedItem,
        isExpanded: true,
        dropdownColor: hexStringToColor("E8EDF2"),
        iconSize: 36,
        style: TextStyle(
          color: hexStringToColor("4F7396"),
          fontSize: 18,
        ),
        borderRadius: BorderRadius.circular(30),
        onChanged: onChanged,
        items:
            <int>[10, 20, 30, 40, 50].map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('$value'), // Convert integer to string
            ),
          );
        }).toList(),
      ),
    );
  }
}
