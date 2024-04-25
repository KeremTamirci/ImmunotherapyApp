import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

class OTPPage extends StatelessWidget {
  final String otp;

  const OTPPage({Key? key, required this.otp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One Time Password'),
        backgroundColor: hexStringToColor("6495ED"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is your one-time password:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              otp,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: otp));
                Navigator.pop(context);
              },
              child: Text('Copy Password'),
            ),
          ],
        ),
      ),
    );
  }
}
