import 'package:flutter/material.dart';
import 'package:immunotheraphy_app/patient/screens/dose_intake_page.dart';
import 'package:immunotheraphy_app/patient/screens/form_page.dart';
import 'package:immunotheraphy_app/utils/color_utils.dart';

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
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InformationBox(
                  title: 'Doz Girişi',
                  onTap: () {
                    // Add your onTap logic for Box 1 here
                    print('Box 1 tapped');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FormPage(),
                        ));
                  },
                  icon: Icons.list,
                  // color: hexStringToColor("3DED97"),
                  linearGradient: LinearGradient(colors: [
                    hexStringToColor("3DED97"),
                    hexStringToColor("18C872")
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                InformationBox(
                  title: 'Semptom Girişi',
                  onTap: () {
                    // Add your onTap logic for Box 2 here
                    print('Box 2 tapped');
                  },
                  icon: Icons.sick,
                  // color: hexStringToColor("1A80E5"),
                  linearGradient: LinearGradient(colors: [
                    hexStringToColor("3FA5FF"),
                    hexStringToColor("1A80E5")
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  // color: hexStringToColor("D90429"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: 10, // Change this to your actual list length
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                  subtitle: Text('Subtitle $index'),
                  onTap: () {
                    // Add your onTap logic for list items here
                    print('List item $index tapped');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int getPatientDoseNumber() {
    return 3;
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
        height: 210,
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
              size: 70,
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
            const ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: Text(
                "Başla",
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
