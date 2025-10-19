import 'package:flutter/material.dart';

class BatterySection extends StatelessWidget {
  final double batteryLevel; // 0.0 a 1.0
  final bool isActive; // si hay reserva activa

  const BatterySection({
    super.key,
    required this.batteryLevel,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (batteryLevel * 100).toInt();

    final Color progressColor = isActive ? const Color(0xFF2ECC71) : Colors.grey;
    final Color backgroundColor = isActive ? const Color(0xFFA8E6A3) : Colors.grey[300]!;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: isActive ? batteryLevel : 1.0, // círculo lleno gris si no hay carga
                strokeWidth: 22,
                color: progressColor,
                backgroundColor: backgroundColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$percentage%",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isActive ? "35 min restantes" : "Sin carga",
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  isActive ? "Cargando" : "",
                  style: TextStyle(
                    color: isActive ? const Color(0xFF2ECC71) : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
