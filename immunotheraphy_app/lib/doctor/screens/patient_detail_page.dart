import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/doctor/utils/firebase_initialization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PatientDetailScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.patientDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailItem(AppLocalizations.of(context)!.name, patient.firstName),
            _buildDetailItem(AppLocalizations.of(context)!.surname, patient.lastName),
            _buildDetailItem(AppLocalizations.of(context)!.phoneNumber, patient.phoneNumber),
            _buildDetailItem(AppLocalizations.of(context)!.birthDate, _formatDate(patient.birthDate)),
            _buildDetailItem(AppLocalizations.of(context)!.hasRhinitis, patient.hasRhinits ?  AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
            _buildDetailItem(AppLocalizations.of(context)!.hasAsthma, patient.hasAsthma ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
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
    return '${date.day}/${date.month}/${date.year}'; // Format date as desired
  }
}
