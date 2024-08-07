// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, file_names

import 'package:accordion/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/infoSheets/SymptomsInfoSheet.dart';
import 'package:immunotheraphy_app/patient/utils/animated_dropdown.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SymptomsInfoPage extends StatefulWidget {
  const SymptomsInfoPage({super.key});

  @override
  _SymptomsInfoPageState createState() => _SymptomsInfoPageState();
}

class _SymptomsInfoPageState extends State<SymptomsInfoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
  }

  void _initializeYoutubePlayer() {
    const videoURL = "https://youtu.be/zHBrWm0faso?si=IX9Zu0vvoqfLT1LB";
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutAnaphylaxis),
        actions: [
          DialogTextButton(
            "Bitti",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
              // height: 200,
              child: Image(
                image: AssetImage("assets/images/penepin_upscaled.png"),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.anaphylaxisTitle,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                AppLocalizations.of(context)!.symptomsExplanation,
                style: const TextStyle(fontSize: 16),
              ),
            ),
/*            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: YoutubePlayer(
                      controller: _controller,
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _launchYouTubeVideo,
                        style: const ButtonStyle(
                          surfaceTintColor: MaterialStatePropertyAll(
                              CupertinoColors.systemBackground),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 255, 0, 0)),
                          foregroundColor:
                              MaterialStatePropertyAll(CupertinoColors.white),
                        ),
                        icon: const Icon(Icons.ondemand_video_rounded),
                        label:
                            Text(AppLocalizations.of(context)!.watchOnYoutube),
                      ),
                    ],
                  ),
                ),
              ],
            ), */
            const Padding(
              padding: EdgeInsets.all(28.0),
              child: AnimatedDropdownExample(),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _launchYouTubeVideo() async {
    const url = 'https://youtu.be/zHBrWm0faso?si=IX9Zu0vvoqfLT1LB';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
