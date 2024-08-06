import 'package:flutter/cupertino.dart';
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
  late List<SymptomData> _symptomsData = [];
  bool _loading = true;
  late PatientsFirestoreService _databaseController =
      PatientsFirestoreService();
  DosageData? _lastDosageData;

  @override
  void initState() {
    super.initState();
    _getDosageData();
    _getSymptomsData();
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

  Future<void> _getSymptomsData() async {
    try {
      List<SymptomData> symptomsData =
          await _databaseController.getSymptomsData(widget.patient.patientId);
      setState(() {
        _symptomsData = symptomsData.reversed.toList();
        _loading = false;
      });
    } catch (e) {
      print('Failed to retrieve dosage data: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  String _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();

    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    int days = today.day - birthDate.day;

    if (days < 0) {
      final previousMonth =
          DateTime(today.year, today.month - 1, birthDate.day);
      days = today.difference(previousMonth).inDays;
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }
    print(widget.patient.allergyType);
    return '$years ${AppLocalizations.of(context)!.yil} ${AppLocalizations.of(context)!.and} $days ${AppLocalizations.of(context)!.gun}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.patient.firstName} ${widget.patient.lastName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 3, // Adjusted to fit text better
                    children: [
                      _buildDetailItem(
                          AppLocalizations.of(context)!.allergyType,
                          widget.patient.allergyType,
                          Icons.edit_note),
                      _buildDetailItem(
                          AppLocalizations.of(context)!.birthDate,
                          _formatDate(widget.patient.birthDate),
                          Icons.calendar_month),
                      _buildDetailItem(
                          AppLocalizations.of(context)!.phoneNumber,
                          widget.patient.phoneNumber,
                          Icons.call),
                      _buildDetailItem(
                          AppLocalizations.of(context)!.age,
                          _calculateAge(widget.patient.birthDate).toString(),
                          Icons.cake),
                      _buildDetailItem(
                        AppLocalizations.of(context)!.gender,
                        widget.patient.gender == "Female" ||
                                widget.patient.gender == "Male"
                            ? AppLocalizations.of(context)!.female
                            : AppLocalizations.of(context)!.male,
                        Icons.person,
                      ),
                      _buildDetailItem(
                          AppLocalizations.of(context)!.hasRhinitis,
                          widget.patient.hasRhinits
                              ? AppLocalizations.of(context)!.yes
                              : AppLocalizations.of(context)!.no,
                          Icons.assignment_outlined),
                      _buildDetailItem(
                          AppLocalizations.of(context)!.hasAsthma,
                          widget.patient.hasAsthma
                              ? AppLocalizations.of(context)!.yes
                              : AppLocalizations.of(context)!.no,
                          Icons.assignment_outlined),
                      _buildDetailItem(
                        AppLocalizations.of(context)!.lastDosage,
                        _lastDosageData != null
                            ? DateFormat('dd.MM.yy  HH:mm')
                                .format(_lastDosageData!.date)
                            : "-",
                        Icons.vaccines,
                      ),
                      _buildDetailItem(
                        AppLocalizations.of(context)!.atopicDermatitis,
                        widget.patient.hasAtopicDermatitis
                            ? AppLocalizations.of(context)!.yes
                            : AppLocalizations.of(context)!.no,
                        Icons.assessment_outlined,
                      ),
                      _buildDetailItem(
                        AppLocalizations.of(context)!.dosageAmount,
                        _lastDosageData != null
                            ? _lastDosageData!.amount.toString()
                            : "-",
                        Icons.vaccines,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _showDosageChart,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust the size to fit the content
                        children: [
                          const Icon(Icons.timeline,
                              color:
                                  Colors.white), // Add your desired icon here
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.doseChart,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showSymptomsList,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Adjust the size to fit the content
                      children: [
                        const Icon(Icons.pan_tool,
                            color: Colors.white), // Add your desired icon here
                        const SizedBox(
                            width:
                                10), // Add some space between the icon and the text
                        Text(
                          AppLocalizations.of(context)!.symptoms,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  //if (_lastDosageData != null) _buildLastDosageIntake(),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Card(
      surfaceTintColor: CupertinoColors.systemBackground,
      color: CupertinoColors.systemBackground,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 24), // Add your desired icon here
            const SizedBox(width: 10), // Space between the icon and the column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDosageChart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Set the desired radius here
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  20.0), // Ensure Container respects border radius
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDosageChart(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _dosageData.length,
                    itemBuilder: (context, index) {
                      final dosage = _dosageData.reversed.toList();
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
                const SizedBox(height: 20), // Adds some space above the button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.goBack),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSymptomsList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Set the desired radius here
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  20.0), // Ensure Container respects border radius
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(child: _buildSymptomsList()),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.goBack),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSymptomsList() {
    if (_symptomsData.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noSymptoms));
    }
    return ListView.builder(
      itemCount: _symptomsData.length,
      itemBuilder: (context, index) {
        SymptomData symptom = _symptomsData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.symptomType}: ${symptom.type}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${AppLocalizations.of(context)!.date}: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(symptom.date)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  '${AppLocalizations.of(context)!.detail}: ${symptom.detail}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDosageChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.doseChart,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(
                text:
                    AppLocalizations.of(context)!.date, // Horizontal axis title
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: AppLocalizations.of(context)!
                    .dosageAmount, // Vertical axis title
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            legend:
                const Legend(isVisible: true, toggleSeriesVisibility: false),
            series: <LineSeries<DosageData, DateTime>>[
              LineSeries<DosageData, DateTime>(
                dataSource: _dosageData,
                xValueMapper: (DosageData data, _) => data.date,
                yValueMapper: (DosageData data, _) => data.amount,
                name: AppLocalizations.of(context)!.dosageEntries,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(
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
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  borderColor: Colors.red,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppLocalizations.of(context)!.date}: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(_lastDosageData!.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${AppLocalizations.of(context)!.amount}: ${_lastDosageData!.amount}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${AppLocalizations.of(context)!.location}: ${_lastDosageData!.isHospital ? AppLocalizations.of(context)!.hospital : AppLocalizations.of(context)!.homeLocation}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
