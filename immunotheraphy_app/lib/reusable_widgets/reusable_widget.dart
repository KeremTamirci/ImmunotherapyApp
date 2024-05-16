// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller, {
  VoidCallback? onTap,
  double? scrollPadding,
}) {
  return TextField(
    controller: controller,
    onTap: onTap,
    scrollPadding: EdgeInsets.only(bottom: scrollPadding ?? 20),
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(
    BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),

      ), child: 
      Text(title,
      style:    const TextStyle( color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}

class DoseChart extends StatelessWidget {
  final List<double> doses;
  final List<String> dates;
  final List<bool> isHospitalList;
  final List<(String, bool)> tookDoseList;


  DoseChart(
      {required this.doses,
      required this.dates,
      required this.isHospitalList,
      required this.tookDoseList});

  @override
  Widget build(BuildContext context) {
    if (doses.isEmpty || dates.isEmpty) {
      // Return an empty graph widget
      return SizedBox(
        height: 300,
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 0,
              bottom: 70,
              child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  'Doz miktarı (mg)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Center(
                child: Text(
                  'Tarih',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 50.0),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(topTitles: AxisTitles(), show: true),
                  borderData: FlBorderData(
                    show: true,
                  ),
                  // Set minY and maxY values to add padding
                  minY: 0,
                  maxY: 50,
                ),
              ),
            ),
          ],
        ),

      );
    }

    // Find the minimum and maximum values in the doses list
    double minValue = doses.reduce((curr, next) => curr < next ? curr : next);
    double maxValue = doses.reduce((curr, next) => curr > next ? curr : next);

    // Calculate the padding percentage (adjust this value based on your preference)
    double paddingPercentage = 0.1;

    // Calculate padding values
    double paddingMax = (maxValue - minValue) * paddingPercentage;

    // Adjust minY and maxY values with padding
    double maxY = maxValue + paddingMax;

    List<Color> spotColors = isHospitalList
        .map((isHospital) => isHospital ? Colors.red : Colors.blue)
        .toList();

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          const Positioned(
            left: 5,
            top: 0,
            bottom: 70,
            child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                'Doz miktarı (mg)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 10,
            child: Center(
              child: Text(
                'Tarih',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 50.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(topTitles: AxisTitles(), show: true),
                borderData: FlBorderData(
                  show: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    preventCurveOverShooting: true,
                    spots: doses.asMap().entries.map((entry) {
                      return FlSpot(
                          entry.key.toDouble(), entry.value.toDouble());
                    }).toList(),
                    //isCurved: true,
                    gradient: LinearGradient(colors: spotColors),
                    //color: spotColors[],
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                // Set minY and maxY values to add padding
                minY: 0,
                maxY: maxY >= 50 ? maxY : 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDropdownWidget extends StatelessWidget {
  final int selectedItem;
  final ValueChanged<int?> onChanged;

  const MyDropdownWidget({
    super.key,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: selectedItem,
        isExpanded: true,
        // dropdownColor: hexStringToColor("E8EDF2"),
        iconSize: 36,
        style: const TextStyle(
          // color: hexStringToColor("4F7396"),
          fontSize: 18,
        ),
        borderRadius: BorderRadius.circular(30),
        onChanged: onChanged,
        items:
            <int>[10, 20, 30, 40, 50].map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('$value'), // Convert integer to string
            ),
          );
        }).toList()
      )
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),

      ),
    );
  }
}
