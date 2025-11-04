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
  bool hasActiveReservation = false;
  bool inQueue = false;
  int queuePosition = 0;
  int usersInQueue = 0;
  double batteryLevel = 0.0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 60),

              // Estado de cargadores
              const StatusRow(
                available: 2,
                occupied: 1,
              ),
              const SizedBox(height: 50),

              // Icono de batería pequeño
              BatteryIcon(batteryLevel: batteryLevel),
              const SizedBox(height: 30),

              // Indicador circular grande
              BatterySection(
                batteryLevel: batteryLevel,
                isActive: hasActiveReservation,
                isWaiting: inQueue,
                queuePosition: queuePosition,
                usersInQueue: usersInQueue,
                remainingMinutes: queuePosition * 15,
              ),

              const SizedBox(height: 60),

              // Botones de acción
              ActionButtons(
                hasActiveReservation: hasActiveReservation,
                onStop: hasActiveReservation ? _stopCharging : null,
                onReserve: _goToReservationPage,
              ),
              const SizedBox(height: 50),

              // Nueva sección: FILA VIRTUAL
              _buildQueueSection(),

              const SizedBox(height: 50),
              Divider(
                color: Colors.grey[400],
                thickness: 1,
                height: 80,
              ),

              // Botón para abrir chat
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[200],
                  foregroundColor: Colors.green[900],
                  minimumSize: const Size(280, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 26),
                label: const Text(
                  "Abrir chat",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// --- SECCIÓN DE FILA VIRTUAL ---
  Widget _buildQueueSection() {
    return Column(
      children: [
        Text(
          inQueue
              ? "Estás en la fila (posición $queuePosition)"
              : "No estás en la fila",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          "Usuarios en espera: $usersInQueue",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(inQueue ? Icons.exit_to_app : Icons.hourglass_bottom),
          label: Text(inQueue ? "Salir de la fila" : "Unirse a la fila"),
          style: ElevatedButton.styleFrom(
            backgroundColor: inQueue ? Colors.redAccent : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            minimumSize: const Size(250, 50),
          ),
          onPressed: _toggleQueue,
        ),
      ],
    );
  }

  /// --- LÓGICA DE FILA ---
  void _toggleQueue() {
    if (!inQueue) {
      setState(() {
        inQueue = true;
        usersInQueue++;
        queuePosition = usersInQueue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Te uniste a la fila. Posición: $queuePosition'),
        ),
      );

      // Simulación: si eres el primero, comienzas a cargar
      if (queuePosition == 1) {
        Future.delayed(const Duration(seconds: 3), _startCharging);
      }
    } else {
      setState(() {
        inQueue = false;
        usersInQueue--;
        queuePosition = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saliste de la fila')),
      );
    }
  }

  void _startCharging() {
    if (!mounted || !inQueue) return;

    setState(() {
      hasActiveReservation = true;
      inQueue = false;
      queuePosition = 0;
      usersInQueue = (usersInQueue > 0) ? usersInQueue - 1 : 0;
      batteryLevel = 0.2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comenzando carga ⚡')),
    );

    _simulateCharging();
  }

  void _simulateCharging() async {
    while (batteryLevel < 1.0 && hasActiveReservation && mounted) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        batteryLevel = (batteryLevel + 0.1).clamp(0.0, 1.0);
      });
    }

    if (mounted && hasActiveReservation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carga completada ✅')),
      );
      setState(() => hasActiveReservation = false);
    }
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
