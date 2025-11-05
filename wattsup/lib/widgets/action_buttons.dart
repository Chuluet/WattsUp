import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool hasActiveReservation;
  final VoidCallback? onStop;
  final VoidCallback? onReserve;

  const ActionButtons({
    super.key,
    required this.hasActiveReservation,
    this.onStop,
    this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onStop != null) ...[
          // 🔴 Botón detener carga - Mismo estilo del primer código
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F2F2),
              foregroundColor: Colors.black,
              minimumSize: const Size(260, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onStop,
            icon: const Icon(Icons.stop, size: 24),
            label: const Text(
              "Detener carga",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        if (onReserve != null) ...[
          const SizedBox(height: 16), // Espacio entre botones como en el primer código
          // 🟩 Botón reservar cargador - Mismo estilo del primer código
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