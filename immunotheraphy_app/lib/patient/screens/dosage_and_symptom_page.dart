import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immunotheraphy_app/patient/screens/add_symptom_page.dart';
// import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:immunotheraphy_app/patient/screens/form_page.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DosageAndSymptomPage extends StatefulWidget {
  const DosageAndSymptomPage({super.key});

  @override
  State<DosageAndSymptomPage> createState() => _DosageAndSymptomPageState();
}

class _DosageAndSymptomPageState extends State<DosageAndSymptomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Information Page'),
        // ),
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InformationBox(
                title: AppLocalizations.of(context)!.dosageEntry,
                onTap: () {
                  print('Box 1 tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FormPage(),
                    ),
                  );
                },
                icon: Icons.list,
                linearGradient: LinearGradient(
                  colors: [
                    hexStringToColor("3DED97"),
                    hexStringToColor("18C872")
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              InformationBox(
                title: AppLocalizations.of(context)!.symptomEntry,
                onTap: () {
                  print('Box 2 tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSymptomsPage(),
                    ),
                  );
                },
                icon: Icons.sick,
                linearGradient: LinearGradient(
                  colors: [
                    hexStringToColor("3FA5FF"),
                    hexStringToColor("1A80E5")
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(
              AppLocalizations.of(context)!.informationalEntries,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoCardWidget(
                  title: AppLocalizations.of(context)!.aboutSymptoms,
                  description:
                      AppLocalizations.of(context)!.whatToDo,
                  imagePath: "assets/images/kalp_atisi.png",
                ),
                InfoCardWidget(
                  title: AppLocalizations.of(context)!.milkLadder,
                  description: AppLocalizations.of(context)!.milkLadderSubtitle,
                  imagePath: "assets/images/sut_ana_resim.png",
                ),
                InfoCardWidget(
                  title: 'Alerjik Besinler',
                  description: "Yaygın besin alerjileri",
                  imagePath: "assets/images/armut_yiyen_adam.png",
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  int getPatientDoseNumber() {
    return 3;
  }
}

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  const InfoCardWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        // shadowColor: Color.fromARGB(255, 255, 14, 14),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
          onTap: () {
            debugPrint('Card $title tapped.');
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Text(
                                  "Yazı Başlığı",
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ), // Replace YourImageWidget with your image widget
                ),
                Expanded(
                  flex: description.length > 50 ? 4 : 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class InformationBox extends StatelessWidget {
//   const InformationBox({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class InformationBox extends StatelessWidget {
  final String title;
  final IconData icon;
  // final Color color;
  final LinearGradient linearGradient;
  final void Function()? onTap;

  const InformationBox({
    super.key,
    required this.title,
    required this.icon,
    // required this.color,
    required this.onTap,
    required this.linearGradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.44,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          gradient: linearGradient,
          // color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(
              icon,
              size: MediaQuery.of(context).size.height * 0.08,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: Text(
                AppLocalizations.of(context)!.start,
                style: TextStyle(fontSize: 16),
              ),
            )
            // const Text(
            //   "Başla",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
