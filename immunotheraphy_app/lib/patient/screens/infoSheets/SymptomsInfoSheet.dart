// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, file_names

import 'package:accordion/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/utils/animated_dropdown.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
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
      minChildSize: 0.9,
      maxChildSize: 0.9,
      snap: true,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  // height: 75,
                  width: double.infinity,
                  // color: Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/images/kalp_atisi.png"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.aboutAnaphylaxis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.arrow_back_ios_rounded,
                      //     // color: Colors.white,
                      //   ),
                      //   onPressed: () => Navigator.of(context).pop(),
                      // ),
                      DialogTextButton(
                        "Bitti",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // const SizedBox(height: 10),
                        const SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Image(
                            image: AssetImage("assets/images/kalp_atisi.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.anaphylaxisTitle,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .symptomsExplanation,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Card(
                              //   surfaceTintColor: CupertinoColors.systemBackground,
                              //   color: CupertinoColors.systemGrey6,
                              //   shadowColor: CupertinoColors.systemBackground,
                              //   elevation: 1,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15.0),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(16.0),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             const Text(
                              //               "Video:",
                              //               style: TextStyle(
                              //                   fontSize: 24,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //             ElevatedButton.icon(
                              //               onPressed: _launchYouTubeVideo,
                              //               icon: const Icon(
                              //                   Icons.ondemand_video_rounded),
                              //               label: Text(
                              //                   AppLocalizations.of(context)!
                              //                       .watchOnYoutube),
                              //             ),
                              //           ],
                              //         ),
                              //         const SizedBox(height: 10),
                              //         YoutubePlayer(
                              //           controller: _controller,
                              //           bottomActions: [
                              //             CurrentPosition(),
                              //             ProgressBar(isExpanded: true),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        ElevatedButton.icon(
                                          onPressed: _launchYouTubeVideo,
                                          style: const ButtonStyle(
                                              surfaceTintColor:
                                                  MaterialStatePropertyAll(
                                                      CupertinoColors
                                                          .systemBackground),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color.fromARGB(
                                                          255, 255, 0, 0)),
                                              foregroundColor:
                                                  MaterialStatePropertyAll(
                                                      CupertinoColors.white)),
                                          icon: const Icon(
                                              Icons.ondemand_video_rounded),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .watchOnYoutube),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(28.0),
                                child: AnimatedDropdownExample(),
                              ),
                              const SizedBox(height: 20),
                              ///////////////////////////////////////////////////////////
                              // UNCOMMENT HERE FOR ACCORDION CODE
                              // _buildAccordion(),
                              ///////////////////////////////////////////////////////////
                              // const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccordion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Accordion(
        maxOpenSections: 1,
        // headerBackgroundColor: const Color(0xFF2196F3),
        headerBackgroundColor: CupertinoColors.systemBackground,
        headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        // headerBorderColor: CupertinoColors.systemGrey,
        // headerBorderWidth: 0.5,
        contentBorderColor: CupertinoColors.systemBackground,
        rightIcon: const Icon(
          Icons.keyboard_arrow_down,
        ),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        scaleWhenAnimating: false,
        scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
        disableScrolling: true,
        children: [
          AccordionSection(
            isOpen: false,
            scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
            header: Text(
              AppLocalizations.of(context)!.skinSystem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
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
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
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
                          size: 20, color: Color.fromARGB(255, 126, 6, 0)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.skinSystemExplanation,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AccordionSection(
            isOpen: false,
            scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
            header: Text(
              AppLocalizations.of(context)!.respiratorySystem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
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
                            size: 20, color: Color.fromARGB(255, 126, 6, 0)),
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
            scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
            header: Text(
              AppLocalizations.of(context)!.gastrointestinalSystem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
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
                            size: 20, color: Color.fromARGB(255, 126, 6, 0)),
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
            scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
            header: Text(
              AppLocalizations.of(context)!.cardiovascularSystem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
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
                          size: 20, color: Color.fromARGB(255, 126, 6, 0)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.applyAdrenaline,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

class AnimatedDropdownExample extends StatelessWidget {
  const AnimatedDropdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Divider(thickness: 0.5, color: CupertinoColors.systemGrey),
        const SizedBox(height: 10),
        AnimatedDropdown(
          title: AppLocalizations.of(context)!.skinSystem,
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
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
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
                        size: 20, color: Color.fromARGB(255, 126, 6, 0)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.skinSystemExplanation,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 0.5, color: CupertinoColors.systemGrey),
        const SizedBox(height: 10),
        AnimatedDropdown(
          title: AppLocalizations.of(context)!.respiratorySystem,
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
                          size: 20, color: Color.fromARGB(255, 126, 6, 0)),
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
        const SizedBox(height: 10),
        const Divider(thickness: 0.5, color: CupertinoColors.systemGrey),
        const SizedBox(height: 10),
        AnimatedDropdown(
          title: AppLocalizations.of(context)!.gastrointestinalSystem,
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
                          size: 20, color: Color.fromARGB(255, 126, 6, 0)),
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
        const SizedBox(height: 10),
        const Divider(thickness: 0.5, color: CupertinoColors.systemGrey),
        const SizedBox(height: 10),
        AnimatedDropdown(
          title: AppLocalizations.of(context)!.cardiovascularSystem,
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
                        size: 20, color: Color.fromARGB(255, 126, 6, 0)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.applyAdrenaline,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 0.5, color: CupertinoColors.systemGrey),
        const SizedBox(height: 10),

        // AnimatedDropdown(
        //   title: 'Another Dropdown',
        //   content: 'This is another example of a dropdown.',
        // ),
      ],
    );
  }
}
