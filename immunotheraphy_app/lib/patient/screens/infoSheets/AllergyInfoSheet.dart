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
                        AppLocalizations.of(context)!.allergicFoods,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Text(
                              AppLocalizations.of(context)!.allergyInfo,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Text(
                              AppLocalizations.of(context)!.commonFoodAllergies,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          _buildCard(
                            context,
                            AppLocalizations.of(context)!.milkAllergy,
                            [
                              AppLocalizations.of(context)!
                                  .milkAllergySymptoms1,
                              AppLocalizations.of(context)!
                                  .milkAllergySymptoms2,
                              AppLocalizations.of(context)!
                                  .milkAllergySymptoms3,
                              AppLocalizations.of(context)!.milkAllergySymptoms4
                            ],
                          ),
                          _buildCard(
                            context,
                            AppLocalizations.of(context)!.nutAllergy,
                            [
                              AppLocalizations.of(context)!.nutAllergySymptoms1,
                              AppLocalizations.of(context)!.nutAllergySymptoms2,
                              AppLocalizations.of(context)!.nutAllergySymptoms3,
                              AppLocalizations.of(context)!.nutAllergySymptoms4
                            ],
                          ),
                          _buildCard(
                            context,
                            AppLocalizations.of(context)!.sesameAllergy,
                            [
                              AppLocalizations.of(context)!
                                  .sesameAllergySymptoms1,
                              AppLocalizations.of(context)!
                                  .sesameAllergySymptoms2,
                              AppLocalizations.of(context)!
                                  .sesameAllergySymptoms3,
                              AppLocalizations.of(context)!
                                  .sesameAllergySymptoms4
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
}
