import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunotheraphy_app/patient/utils/database_controller.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      List<DosageData> dosageData =
          await _databaseController.getSortedDosageData();
      setState(() {
        _dosageData = dosageData;
      });
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
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

  Future<void> _deleteDosage(DateTime date) async {
    try {
      await _databaseController.deleteDosage(date);
      _getDosageData();
    } catch (e) {
      print('Failed to delete dosage: $e');
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          text: AppLocalizations.of(context)!.date,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: AppLocalizations.of(context)!.dosageAmount,
                          textStyle: const TextStyle(
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
                            isVisible: true,
                            shape: DataMarkerType.circle,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0), // Simulate card margin
                      child: Slidable(
                        key: Key(dosage[index].date.toString()),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              onPressed: (context) =>
                                  _deleteDosage(dosage[index].date),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      8.0), // Adjust padding to align with card height
                            ),
                          ],
                        ),
                        child: Card(
                          color: CupertinoColors.white,
                          surfaceTintColor: CupertinoColors.white,
                          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: ListTile(
                            title: Text(
                              '${AppLocalizations.of(context)!.dosageAmount}: ${dosage[index].amount}',
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dosage[index].date)}',
                            ),
                            trailing: dosage[index].watering != null &&
                                    dosage[index].watering!.isNotEmpty
                                ? Text(
                                    '${AppLocalizations.of(context)!.watering}: ${dosage[index].watering}',
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
