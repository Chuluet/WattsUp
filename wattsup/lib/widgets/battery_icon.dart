import 'package:flutter/material.dart';

class BatteryIcon extends StatelessWidget {
  final double batteryLevel; // Nivel de 0.0 a 1.0

  const BatteryIcon({super.key, required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    Color batteryColor;
    if (batteryLevel >= 0.8) {
      batteryColor = Colors.green;
    } else if (batteryLevel >= 0.3) {
      batteryColor = Colors.orange;
    } else {
      batteryColor = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.battery_full, color: batteryColor, size: 30),
        const SizedBox(width: 8),
        Text(
          "${(batteryLevel * 100).toInt()}%",
          style: TextStyle(fontSize: 16, color: batteryColor),
        ),
      ],
    );
  }
}

