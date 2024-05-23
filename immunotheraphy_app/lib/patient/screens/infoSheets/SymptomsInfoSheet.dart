// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, file_names

import 'package:accordion/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SymptomsInfoSheet extends StatefulWidget {
  const SymptomsInfoSheet({super.key});

  @override
  _SymptomsInfoSheetState createState() => _SymptomsInfoSheetState();
}

class _SymptomsInfoSheetState extends State<SymptomsInfoSheet> {
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
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    // color: Color(0xFF2196F3),
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/kalp_atisi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.aboutAnaphylaxis,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.anaphylaxisTitle,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.symptomsExplanation,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Card(
                            surfaceTintColor: CupertinoColors.systemBackground,
                            color: CupertinoColors.systemGrey6,
                            shadowColor: CupertinoColors.systemBackground,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Video:",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _launchYouTubeVideo,
                                        icon: const Icon(
                                            Icons.ondemand_video_rounded),
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .watchOnYoutube),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  YoutubePlayer(
                                    controller: _controller,
                                    bottomActions: [
                                      CurrentPosition(),
                                      ProgressBar(isExpanded: true),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAccordion(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccordion() {
    return Accordion(
      maxOpenSections: 1,
      headerBackgroundColor: const Color(0xFF2196F3),
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      disableScrolling: true,
      children: [
        AccordionSection(
          isOpen: false,
          header: Text(AppLocalizations.of(context)!.skinSystem,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                AppLocalizations.of(context)!.urtiker,
                AppLocalizations.of(context)!.anjiyoOdem,
                AppLocalizations.of(context)!.kasinti,
                AppLocalizations.of(context)!.kizariklik,
              ].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(
                          child:
                              Text(item, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.skinSystemExplanation,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: Text(AppLocalizations.of(context)!.respiratorySystem,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                AppLocalizations.of(context)!.burunAkitmasi,
                AppLocalizations.of(context)!.hapsirik,
                AppLocalizations.of(context)!.oksuruk,
                AppLocalizations.of(context)!.hirilti,
                AppLocalizations.of(context)!.nefesDarligi,
                AppLocalizations.of(context)!.gogusAgri,
              ].map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(symptom,
                              style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.applyAdrenaline,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: Text(AppLocalizations.of(context)!.gastrointestinalSystem,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                AppLocalizations.of(context)!.karinAgri,
                AppLocalizations.of(context)!.kusma,
                AppLocalizations.of(context)!.ishal,
              ].map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(symptom,
                              style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.applyAdrenaline,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: Text(AppLocalizations.of(context)!.cardiovascularSystem,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                AppLocalizations.of(context)!.kalbinCokHizliAtimlari,
                AppLocalizations.of(context)!.tansiyonDusmesi,
                AppLocalizations.of(context)!.bayginlikHissi,
                AppLocalizations.of(context)!.bayilma,
              ].map((symptom) => Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 8),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(symptom,
                                style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.applyAdrenaline,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchYouTubeVideo() async {
    const url = 'https://youtu.be/zHBrWm0faso?si=IX9Zu0vvoqfLT1LB';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
