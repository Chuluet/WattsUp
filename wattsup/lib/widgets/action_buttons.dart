import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool hasActiveReservation;
  final VoidCallback? onStop;
  final VoidCallback onReserve;

  const ActionButtons({
    super.key,
    required this.hasActiveReservation,
    required this.onStop,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasActiveReservation) ...[
          // 🔴 Botón detener carga
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              hasActiveReservation ? const Color(0xFFF3F2F2) : Colors.grey[300],
              foregroundColor: hasActiveReservation ? Colors.black : Colors.grey,
              minimumSize: const Size(260, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: hasActiveReservation ? onStop : null,
            icon: const Icon(Icons.stop, size: 24),
            label: const Text(
              "Detener carga",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ] else ...[
          // 🟩 Botón reservar cargador
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F2F2),
              foregroundColor: Colors.green[700],
              minimumSize: const Size(260, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onReserve,
            icon: const Icon(Icons.ev_station, size: 24),
            label: const Text(
              "Reservar cargador",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ],
    );
  }
}
