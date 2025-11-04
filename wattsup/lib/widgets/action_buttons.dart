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
        if (onReserve != null) // 👈 solo se muestra si no está en fila ni tiene reserva
          ElevatedButton(
            onPressed: onReserve,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Reservar cargador"),
          ),
        if (onStop != null) // 👈 solo se muestra si hay una reserva activa
          ElevatedButton(
            onPressed: onStop,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Detener carga"),
          ),
      ],
    );
  }
}
