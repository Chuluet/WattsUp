import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF3F2F2),
            foregroundColor: Colors.black,
            minimumSize: const Size(260, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: const Icon(Icons.stop, size: 24),
          label: const Text("Detener carga", style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF3F2F2),
            foregroundColor: Colors.red,
            minimumSize: const Size(260, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: const Icon(Icons.cancel, size: 24),
          label: const Text("Cancelar reserva", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
