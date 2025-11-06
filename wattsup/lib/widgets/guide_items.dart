import 'package:flutter/material.dart';

class GuideItem extends StatelessWidget {
  final String title;

  const GuideItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(Icons.open_in_new, color: Colors.blueGrey),
      ],
    );
  }
}
