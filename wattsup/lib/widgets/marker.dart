import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final double left;
  final double top;
  final Color color;
  final VoidCallback? onTap;

  const Marker({
    super.key,
    required this.left,
    required this.top,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.ev_station,
          size: 40,
          color: color,
        ),
      ),
    );
  }
}
