import 'package:flutter/material.dart';

class QueuePage extends StatefulWidget {
  final int queueLength;
  final bool alreadyInQueue;
  final bool hasActiveReservation;
  final VoidCallback onJoinQueue;

  const QueuePage({
    super.key,
    required this.queueLength,
    required this.alreadyInQueue,
    required this.hasActiveReservation,
    required this.onJoinQueue,
  });

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  @override
  Widget build(BuildContext context) {
    // Si no hay personas en la fila, mostramos valores por defecto
    final int displayedQueue = widget.queueLength > 0 ? widget.queueLength : 3;
    final int estimatedMinutes = displayedQueue * 15;
    final bool canJoin =
        !widget.alreadyInQueue && !widget.hasActiveReservation;

    // Simulamos usuarios con diferentes estados
    final List<Map<String, String>> queueUsers = [
      {"nombre": "Laura", "estado": "Terminando", "icon": "battery_charging_full"},
      {"nombre": "Carlos", "estado": "En turno", "icon": "ev_station"},
      {"nombre": "Ana", "estado": "En espera", "icon": "hourglass_empty"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fila virtual"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 🧾 Información general
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.ev_station, color: Colors.green, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    "Personas en la fila: $displayedQueue",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tiempo estimado hasta tu turno:",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$estimatedMinutes minutos",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 👥 Lista de usuarios en fila
            Expanded(
              child: ListView.builder(
                itemCount: queueUsers.length,
                itemBuilder: (context, index) {
                  final user = queueUsers[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForState(user["icon"]!),
                          color: Colors.green,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["nombre"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user["estado"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: user["estado"] == "En espera"
                                    ? Colors.orange
                                    : user["estado"] == "En turno"
                                    ? Colors.green
                                    : Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Botón para unirse a la fila
            ElevatedButton.icon(
              onPressed: canJoin
                  ? () {
                widget.onJoinQueue();
                Navigator.pop(context, true);
              }
                  : null,
              icon: const Icon(Icons.timer),
              label: Text(
                widget.alreadyInQueue
                    ? "Ya estás en la fila"
                    : widget.hasActiveReservation
                    ? "Tienes una reserva activa"
                    : "Unirme a la fila",
                style: const TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Puedes salir de la fila en cualquier momento desde la pantalla principal.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForState(String iconName) {
    switch (iconName) {
      case "battery_charging_full":
        return Icons.battery_charging_full;
      case "hourglass_empty":
        return Icons.hourglass_empty;
      case "ev_station":
      default:
        return Icons.ev_station;
    }
  }
}
