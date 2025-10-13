import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.circle, color: Colors.green, size: 30),
        SizedBox(width: 6),
        Text("2 disponibles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        SizedBox(width: 20),
        Icon(Icons.circle, color: Colors.red, size: 30),
        SizedBox(width: 6),
        Text("1 ocupado", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
      ],
    );
  }
}
