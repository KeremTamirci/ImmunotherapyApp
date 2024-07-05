import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/utils/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class AllergyInfoSheet extends StatelessWidget {
  const AllergyInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
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
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(16.0),
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage("assets/images/armut_yiyen_adam.png"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       IconButton(
                //         icon: const Icon(Icons.arrow_back_ios_rounded),
                //         onPressed: () => Navigator.of(context).pop(),
                //       ),
                //     ],
                //   ),
                // ),
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
                              image: AssetImage(
                                  "assets/images/armut_yiyen_adam.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Text(
                              "Alerji Bilgileri",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Text(
                              "Aşağıda süt, fındık ve susam alerjileri hakkında bilgi bulabilirsiniz.",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          _buildCard(
                            context,
                            "Süt Alerjisi",
                            [
                              'Ciltte kızarıklık ve kaşıntı',
                              'Karın ağrısı, bulantı, ishal',
                              'Öksürük, hırıltı',
                              'Nadir durumlarda anafilaksi'
                            ],
                          ),
                          _buildCard(
                            context,
                            "Fındık Alerjisi",
                            [
                              'Ciltte döküntü ve kaşıntı',
                              'Mide krampları, bulantı, ishal',
                              'Nefes darlığı, hırıltı',
                              'Şiddetli alerjik reaksiyon (anafilaksi)'
                            ],
                          ),
                          _buildCard(
                            context,
                            "Susam Alerjisi",
                            [
                              'Kurdeşen, kızarıklık',
                              'Karın ağrısı, bulantı, ishal',
                              'Burun akıntısı, nefes darlığı',
                              'Şiddetli alerjik reaksiyon (anafilaksi)'
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, String title, List<String> symptoms) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: symptoms.map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            Text(symptom, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
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
