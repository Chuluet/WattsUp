import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const Marker({
    super.key,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.ev_station,
        size: 40,
        color: color,
      ),
    );
  }
}