import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/screens/choice_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = "en"; // Default language
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RadioListTile(
              title: Text('English'),
              value: 'en',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
              },
            ),
            RadioListTile(
              title: Text('Turkish'),
              value: 'tr',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _saveLanguagePreference(selectedLanguage);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ChoiceScreen()),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLanguage', languageCode);
  }
}
