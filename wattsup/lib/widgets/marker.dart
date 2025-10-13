import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final double left;
  final double top;
  final Color color;

  const Marker({super.key, required this.left, required this.top, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Icon(Icons.place, color: color, size: 40),
    );
  }
}
