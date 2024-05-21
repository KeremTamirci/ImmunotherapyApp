import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SymptomsInfoSheet extends StatefulWidget {
  const SymptomsInfoSheet({
    Key? key,
  }) : super(key: key);

  @override
  _SymptomsInfoSheetState createState() => _SymptomsInfoSheetState();
}

class _SymptomsInfoSheetState extends State<SymptomsInfoSheet> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CupertinoColors.systemBackground,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // SizedBox(
              //   height: 40,
              // ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          // const Spacer(),
                          const Text("Anafilaksi Hakkında Yazı",
                              style: TextStyle(fontSize: 16)),
                          // const Spacer(),
                          Row(
                            children: [
                              const Spacer(),
                              CupertinoButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Kapat")),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Anafilaksi (Alerjik Şok) Semptomları:",
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 10),
                      _buildSymptomList([
                        "Deri Sistemi:",
                        "   - Ürtiker",
                        "   - Anjiyo Ödem",
                        "   - Kaşıntı",
                        "   - Kızarıklık",
                      ]),
                      _buildSymptomList([
                        "Solunum Sistemi: (Adrenalin oto-enjektörü uygulayınız)",
                        "   - Burun Akıntısı",
                        "   - Hapşırık",
                        "   - Öksürük",
                        "   - Hırıltı",
                        "   - Nefes Darlığı",
                        "   - Göğüs Ağrısı",
                      ]),
                      _buildSymptomList([
                        "Sindirim Sistemi: (Adrenalin oto-enjektörü uygulayınız)",
                        "   - Karın Ağrısı",
                        "   - Kusma",
                        "   - İshal",
                      ]),
                      _buildSymptomList([
                        "Kalp Sistemi: (Adrenalin oto-enjektörü uygulayınız)",
                        "   - Kalbin Çok Hızlı Atımları",
                        "   - Tansiyon Düşmesi",
                        "   - Baygınlık Hissi",
                        "   - Bayılma",
                      ]),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Video:",
                            style: TextStyle(fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: _launchYouTubeVideo,
                            child: Text("Watch on YouTube"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
    );
  }

  Widget _buildSymptomList(List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: symptoms.map((symptom) => Text(symptom)).toList(),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _launchYouTubeVideo() async {
    const url = 'https://youtu.be/zHBrWm0faso?si=IX9Zu0vvoqfLT1LB';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
