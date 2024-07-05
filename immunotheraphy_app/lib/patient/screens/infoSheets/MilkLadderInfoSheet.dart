import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MilkLadderInfoSheet extends StatelessWidget {
  const MilkLadderInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.8,
      maxChildSize: 0.9,
      snap: true,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/images/sut_ana_resim.png"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.milkLadder,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      DialogTextButton(
                        "Bitti",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_back_ios_rounded),
                      //   onPressed: () => Navigator.of(context).pop(),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Image(
                            image:
                                AssetImage("assets/images/sut_ana_resim.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "Süt Merdiveni",
                            // textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "Aşağıdaki diagramda çeşitli süt ürünlerinin içerdiği süt proteini miktarlarını görüp karşılaştırabilirsiniz.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: RotatedBox(
                            quarterTurns: 0, // Rotates the image 90 degrees
                            child: AspectRatio(
                              aspectRatio:
                                  1.5, // Adjust the aspect ratio as needed
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Image.asset(
                                    "assets/images/Süt_Merdiveni_İngilizce.png"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Image.asset("assets/images/Süt_Merdiveni_İngilizce.png",
                  fit: BoxFit.cover),
              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
