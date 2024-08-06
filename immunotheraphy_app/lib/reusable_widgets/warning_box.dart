import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarningBox extends StatelessWidget {
  const WarningBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: CupertinoColors.destructiveRed.withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Color.fromARGB(255, 126, 6, 0),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.uyari,
                      style: const TextStyle(
                          fontSize: 20,
                          // color: CupertinoColors.systemRed,
                          color: Color.fromARGB(255, 126, 6, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.bulgulardaOneri,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    // color: CupertinoColors.systemRed
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Divider()
        const SizedBox(height: 10)
      ],
    );
  }
}
