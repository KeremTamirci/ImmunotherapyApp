import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:intl/intl.dart';

class DosePage extends StatefulWidget {
  const DosePage({Key? key}) : super(key: key);

  @override
  State<DosePage> createState() => _DosePageState();
}

class _DosePageState extends State<DosePage> {
  late List<DosageData> _dosageData = [];
  late User _user;
  late DatabaseController _databaseController;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getDosageData();
  }

  Future<void> _getDosageData() async {
    try {
      // Call the method to retrieve dosage data from the database controller
      List<DosageData> dosageData =
          await _databaseController.getSortedDosageData();
      setState(() {
        _dosageData = dosageData;
        print(_dosageData.map((data) => data.amount).toList());
      });
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      // Handle error
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosage Progression'),
      ),
      body: Column(
        children: [
          SizedBox(
            child: _dosageData != null
                ? DoseChart(
                    doses: _dosageData.map((data) => data.amount).toList(),
                    dates: _dosageData
                        .map((data) => data.date.toString())
                        .toList(),
                    isHospitalList:
                        _dosageData.map((data) => data.isHospital).toList(),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          SizedBox(height: 20),
          Expanded(
            //height: 200, // Adjust the height as needed
            child: ListView.builder(
              itemCount: _dosageData.length,
              itemBuilder: (context, index) {
                final dosage = _dosageData.reversed.toList()[index];
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(dosage.date);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('Tarih: ${formattedDate}'),
                    subtitle: Text('Doz Miktarı: ${dosage.amount}'),
                    // Add more details if needed
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
