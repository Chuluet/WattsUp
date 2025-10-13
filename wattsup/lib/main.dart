import 'package:flutter/material.dart';
import 'pages/map_page.dart';

void main() {
  runApp(const EVApp());
}

class EVApp extends StatelessWidget {
  const EVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WattsUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MapScreen(),
    );
  }
}
