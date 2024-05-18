import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({Key? key, required this.patient})
      : super(key: key);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late List<DosageData> _dosageData = [];
  bool _loading = true;
  late PatientsFirestoreService _databaseController =
      PatientsFirestoreService();
  DosageData? _lastDosageData;

  @override
  void initState() {
    super.initState();
    _getDosageData();
  }

  Future<void> _getDosageData() async {
    try {
      List<DosageData> dosageData = await _databaseController
          .getSortedDosageData(widget.patient.patientId);
      setState(() {
        _dosageData = dosageData;
        _loading = false;
        if (_dosageData.isNotEmpty) {
          _lastDosageData = _dosageData.last;
        }
      });
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.patientDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _buildDetailItem(AppLocalizations.of(context)!.name,
                      widget.patient.firstName),
                  _buildDetailItem(AppLocalizations.of(context)!.surname,
                      widget.patient.lastName),
                  _buildDetailItem(AppLocalizations.of(context)!.phoneNumber,
                      widget.patient.phoneNumber),
                  _buildDetailItem(AppLocalizations.of(context)!.birthDate,
                      _formatDate(widget.patient.birthDate)),
                  _buildDetailItem(
                      AppLocalizations.of(context)!.hasRhinitis,
                      widget.patient.hasRhinits
                          ? AppLocalizations.of(context)!.yes
                          : AppLocalizations.of(context)!.no),
                  _buildDetailItem(
                      AppLocalizations.of(context)!.hasAsthma,
                      widget.patient.hasAsthma
                          ? AppLocalizations.of(context)!.yes
                          : AppLocalizations.of(context)!.no),
                  const SizedBox(height: 20),
                  _buildDosageChart(),
                  if (_lastDosageData != null) _buildLastDosageIntake(),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDosageChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.doseChart,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          height: 300,
          child: SfCartesianChart(
            onMarkerRender: (MarkerRenderArgs args) {
              if (_dosageData[args.pointIndex!].isHospital) {
                args.color = Colors.red;
                args.borderColor = Colors.red;
              }
            },
            primaryXAxis: DateTimeAxis(),
            legend: Legend(isVisible: true, toggleSeriesVisibility: false),
            series: <LineSeries<DosageData, DateTime>>[
              LineSeries<DosageData, DateTime>(
                dataSource: _dosageData,
                xValueMapper: (DosageData data, _) => data.date,
                yValueMapper: (DosageData data, _) => data.amount,
                name: AppLocalizations.of(context)!.dosageEntries,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  borderColor: Colors.blue,
                  color: Colors.blue,
                ),
              ),
              LineSeries<DosageData, DateTime>(
                dataSource:
                    _dosageData.where((data) => data.isHospital).toList(),
                xValueMapper: (DosageData data, _) => data.date,
                yValueMapper: (DosageData data, _) => data.amount,
                name: AppLocalizations.of(context)!.hospitalDoses,
                opacity: 0,
                color: Colors.red,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  borderColor: Colors.red,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLastDosageIntake() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.lastDosage,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_lastDosageData!.date)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${AppLocalizations.of(context)!.amount}: ${_lastDosageData!.amount}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${AppLocalizations.of(context)!.location}: ${_lastDosageData!.isHospital ? AppLocalizations.of(context)!.hospital : AppLocalizations.of(context)!.homeLocation}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
