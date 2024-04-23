import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _selectedItem = 'Option 1'; // Initial value for dropdown
  TimeOfDay _selectedTime = TimeOfDay.now(); // Initial value for time picker

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

  @override
  Widget build(BuildContext context) {
    return
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[],
        // ),
        Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: 350,
            decoration: BoxDecoration(
                color: hexStringToColor("E8EDF2"),
                borderRadius: BorderRadius.circular(40)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedItem,
                isExpanded: true,
                dropdownColor: hexStringToColor("E8EDF2"),
                iconSize: 36,
                style:
                    TextStyle(color: hexStringToColor("4F7396"), fontSize: 18),
                borderRadius: BorderRadius.circular(30),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                  });
                },
                items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showTimePicker,
            child: const Text('Select Time'),
          ),
          const SizedBox(height: 20),
          Text(
            'Selected Time: ${_selectedTime.hour}:${_selectedTime.minute}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
