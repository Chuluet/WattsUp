import 'package:flutter/material.dart';

class BatteryIcon extends StatelessWidget {
  const BatteryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.battery_full, color: Colors.green, size: 30),
        SizedBox(width: 8),
        Text("Mi carga", style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
