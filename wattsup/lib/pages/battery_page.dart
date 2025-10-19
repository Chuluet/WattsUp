import 'package:flutter/material.dart';
import '../widgets/battery_icon.dart';
import '../widgets/battery_section.dart';
import '../widgets/status_row.dart';
import '../widgets/action_buttons.dart';
import '../pages/chat_page.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  bool hasActiveReservation = false; // Simula si hay carga activa
  double batteryLevel = 0.0; // 0.0 a 1.0

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Handle superior
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Estado de cargadores
            const StatusRow(
              available: 2,
              occupied: 1,
            ),
            const SizedBox(height: 24),

            // Icono de batería pequeño (estética original)
            BatteryIcon(batteryLevel: batteryLevel),
            const SizedBox(height: 16),

            // Indicador circular grande
            BatterySection(
              batteryLevel: batteryLevel,
              isActive: hasActiveReservation,
            ),
            const SizedBox(height: 32),

            // Botones de acción
            ActionButtons(
              hasActiveReservation: hasActiveReservation,
              onStop: hasActiveReservation ? _stopCharging : null,
              onReserve: _goToReservationPage,
            ),
            const SizedBox(height: 32),

            // Botón para abrir chat
            Divider(
              color: Colors.grey[400],
              thickness: 1,
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200],
                foregroundColor: Colors.green[900],
                minimumSize: const Size(260, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 24),
              label: const Text(
                "Abrir chat",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stopCharging() {
    setState(() {
      hasActiveReservation = false;
      batteryLevel = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carga detenida 🔌')),
    );
  }

  void _cancelReservation() {
    setState(() {
      hasActiveReservation = false;
      batteryLevel = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva cancelada ❌')),
    );
  }

  Future<void> _goToReservationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Reserva")),
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Completar reserva"),
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      setState(() {
        hasActiveReservation = true;
        batteryLevel = 0.65;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva activa ✅')),
      );
    }
  }
}
