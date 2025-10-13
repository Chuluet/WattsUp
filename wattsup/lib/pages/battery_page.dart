import 'package:flutter/material.dart';

class BatterySection extends StatelessWidget {
  const BatterySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: 0.65,
                strokeWidth: 22,
                color: const Color(0xFF2ECC71),
                backgroundColor: const Color(0xFFA8E6A3),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              children: const [
                Text(
                  "65%",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "35 min restantes",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 6),
                Text(
                  "Cargando",
                  style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
