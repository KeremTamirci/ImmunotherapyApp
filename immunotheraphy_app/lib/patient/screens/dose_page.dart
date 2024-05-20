import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:immunotheraphy_app/reusable_widgets/reusable_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DosePage extends StatefulWidget {
  const DosePage({super.key});

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
    return MaterialApp(
      title: 'Dosage Data Chart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dosage Data Chart'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  height: 300,
                  child: SfCartesianChart(
                    onMarkerRender: (MarkerRenderArgs args) {
                      if (_dosageData[args.pointIndex!].isHospital) {
                        args.color = Colors.red;
                        args.borderColor = Colors.red;
                      }
                    },
                    primaryXAxis: DateTimeAxis(),
                    legend:
                        Legend(isVisible: true, toggleSeriesVisibility: false),
                    series: <LineSeries<DosageData, DateTime>>[
                      LineSeries<DosageData, DateTime>(
                        dataSource: _dosageData,
                        xValueMapper: (DosageData data, _) => data.date,
                        yValueMapper: (DosageData data, _) => data.amount,
                        name: AppLocalizations.of(context)!.dosageEntries,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        markerSettings: MarkerSettings(
                          isVisible: true, // Show markers
                          shape: DataMarkerType.circle, // Set marker shape
                          borderColor: Colors.blue,
                          color: Colors.blue,
                        ),
                      ),
                      LineSeries<DosageData, DateTime>(
                        dataSource: _dosageData
                            .where((data) => data.isHospital)
                            .toList(),
                        xValueMapper: (DosageData data, _) => data.date,
                        yValueMapper: (DosageData data, _) => data.amount,
                        name: AppLocalizations.of(context)!.hospitalDoses,
                        opacity: 0,
                        color: Colors.red,
                        //dataLabelSettings: DataLabelSettings(isVisible: true),
                        markerSettings: MarkerSettings(
                          isVisible: true, // Show markers
                          shape: DataMarkerType.circle, // Set marker shape
                          borderColor: Colors.red,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _dosageData.length,
                itemBuilder: (context, index) {
                  final dosage = _dosageData.reversed.toList();
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                          '${AppLocalizations.of(context)!.dosageAmount}: ${dosage[index].amount}'),
                      subtitle: Text(
                          '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dosage[index].date)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
