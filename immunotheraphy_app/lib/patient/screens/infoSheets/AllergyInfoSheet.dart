import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class AllergyInfoSheet extends StatelessWidget {
  const AllergyInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/armut_yiyen_adam.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Alerji Bilgileri",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(16.0),
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
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, List<String> symptoms) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
