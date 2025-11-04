import 'package:flutter/material.dart';

class BatterySection extends StatelessWidget {
  final double batteryLevel; // 0.0 a 1.0
  final bool isActive; // Si está cargando
  final bool isWaiting; // Si está en fila
  final int queuePosition; // Posición del usuario en la fila
  final int usersInQueue; // Total en la fila
  final int remainingMinutes; // Minutos estimados

  const BatterySection({
    super.key,
    required this.batteryLevel,
    required this.isActive,
    required this.isWaiting,
    required this.queuePosition,
    required this.usersInQueue,
    required this.remainingMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (batteryLevel * 100).toInt();

    // --- Colores principales ---
    const Color activeColor = Color(0xFF2ECC71);
    const Color waitingColor = Colors.orangeAccent;
    const Color inactiveColor = Colors.grey;

    // --- Progreso según estado (temporal fijo para pruebas) ---
    final double progressValue = 0.75;

    // --- Texto según estado ---
    String mainText;
    String subText;

    if (isActive) {
      mainText = "$percentage%";
      subText = "Cargando ⚡";
    } else if (isWaiting) {
      mainText = "$remainingMinutes min";
      subText = "Esperando turno ⏳";
    } else {
      mainText = "";
      subText = ""; // se reemplaza abajo
    }

    // --- Colores del progreso ---
    final Color mainProgressColor = isActive
        ? activeColor
        : isWaiting
        ? waitingColor
        : inactiveColor;

    final Color secondaryProgressColor = isActive
        ? activeColor.withOpacity(0.35)
        : isWaiting
        ? waitingColor.withOpacity(0.35)
        : inactiveColor.withOpacity(0.3);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // ✅ Sin actividad: círculo sólido
            if (!isActive && !isWaiting)
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 22,
                  color: inactiveColor,
                  backgroundColor: Colors.transparent,
                  strokeCap: StrokeCap.round,
                ),
              )
            else ...[
              // ✅ Con proceso: fondo + barra
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 22,
                  color: secondaryProgressColor,
                  backgroundColor: Colors.transparent,
                  strokeCap: StrokeCap.round,
                ),
              ),
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 22,
                  color: mainProgressColor,
                  backgroundColor: Colors.transparent,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],

            // ✅ Texto central
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isActive && !isWaiting) ...[
                  Text(
                    "No hay actividad",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ] else ...[
                  Text(
                    mainText,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.black
                          : Colors.orange[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: 18,
                      color: isActive
                          ? Colors.grey[700]
                          : Colors.orange[700],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
