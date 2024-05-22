import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: CupertinoColors.systemBackground,
        title: Text(AppLocalizations.of(context)!.doseChart),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      onMarkerRender: (MarkerRenderArgs args) {
                        if (_dosageData[args.pointIndex!].isHospital) {
                          args.color = Colors.red;
                          args.borderColor = Colors.red;
                        }
                      },
                      primaryXAxis: DateTimeAxis(
                        title: AxisTitle(
                          text: AppLocalizations.of(context)!
                              .date, // Horizontal axis title
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: AppLocalizations.of(context)!
                              .dosageAmount, // Vertical axis title
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      legend: const Legend(
                          isVisible: true, toggleSeriesVisibility: false),
                      series: <LineSeries<DosageData, DateTime>>[
                        LineSeries<DosageData, DateTime>(
                          dataSource: _dosageData,
                          xValueMapper: (DosageData data, _) => data.date,
                          yValueMapper: (DosageData data, _) => data.amount,
                          name: AppLocalizations.of(context)!.dosageEntries,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          markerSettings: const MarkerSettings(
                            isVisible: true, // Show markers
                            shape: DataMarkerType.circle, // Set marker shape
                            borderColor: Colors.blue,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: CupertinoScrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: _dosageData.length,
                  itemBuilder: (context, index) {
                    final dosage = _dosageData.reversed.toList();
                    return Card(
                      color: CupertinoColors.white,
                      surfaceTintColor: CupertinoColors.white,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
