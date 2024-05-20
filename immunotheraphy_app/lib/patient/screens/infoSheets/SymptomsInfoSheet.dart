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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Anafilaksi (Alerjik Şok) Semptomları:",
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    _buildAccordion(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Video:",
                          style: TextStyle(fontSize: 24),
                        ),
                        ElevatedButton(
                          onPressed: _launchYouTubeVideo,
                          child: const Text("Watch on YouTube"),
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
