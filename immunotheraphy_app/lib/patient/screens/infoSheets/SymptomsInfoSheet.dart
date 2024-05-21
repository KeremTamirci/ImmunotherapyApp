import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accordion/accordion.dart';

class SymptomsInfoSheet extends StatefulWidget {
  const SymptomsInfoSheet({Key? key}) : super(key: key);

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
    final videoURL = "https://youtu.be/zHBrWm0faso?si=IX9Zu0vvoqfLT1LB";
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                color: Color(0xFF2196F3),
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "Anafilaksi (Alerjik Şok) Semptomları:",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      _buildAccordion(),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Video:",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _launchYouTubeVideo,
                                    icon: const Icon(Icons.ondemand_video_rounded),
                                    label: const Text("Watch on YouTube"),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion() {
    return Accordion(
      maxOpenSections: 1,
      headerBackgroundColor: Color(0xFF2196F3),
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: [
        AccordionSection(
          isOpen: false,
          header: const Text('Deri Sistemi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                'Ürtiker',
                'Anjiyo Ödem',
                'Kaşıntı',
                'Kızarıklık',
              ].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              const Text(
                'Küçük bir alanda ise alerji şurubu veya tableti veriniz ancak ürtiker plakları yaygın ise, anjiyo ödem dilde ise adrenalin yapınız',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: const Text('Solunum Sistemi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                'Burun Akıntısı',
                'Hapşırık',
                'Öksürük',
                'Hırıltı',
                'Nefes Darlığı',
                'Göğüs Ağrısı',
              ].map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(child: Text(symptom, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.error_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Adrenalin oto-enjektörü uygulayınız',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: const Text('Sindirim Sistemi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                'Karın Ağrısı',
                'Kusma',
                'İshal',
              ].map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(child: Text(symptom, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.error_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Adrenalin oto-enjektörü uygulayınız',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        AccordionSection(
          isOpen: false,
          header: const Text('Kalp Sistemi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                'Kalbin Çok Hızlı Atımları',
                'Tansiyon Düşmesi',
                'Baygınlık Hissi',
                'Bayılma',
              ].map((symptom) => Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8),
                    const SizedBox(width: 10),
                    Expanded(child: Text(symptom, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.error_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Adrenalin oto-enjektörü uygulayınız',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
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
