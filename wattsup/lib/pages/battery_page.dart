import 'package:flutter/material.dart';
import '../widgets/battery_icon.dart';
import '../widgets/status_row.dart';
import '../widgets/action_buttons.dart';
import '../pages/chat_page.dart'; // 🟢 nuevo import

class BatteryPage extends StatelessWidget {
  const BatteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Barra gris superior (el "handle" del panel)
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Estado de los cargadores
            const StatusRow(),
            const SizedBox(height: 24),

            // Icono de batería
            const BatteryIcon(),
            const SizedBox(height: 12),

            // Indicador circular de carga
            const BatterySection(),
            const SizedBox(height: 32),

            // Botones de acción principales
            const ActionButtons(),
            const SizedBox(height: 32),

            // 🟩 Nueva sección: Botón para abrir el chat
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
}

class BatterySection extends StatelessWidget {
  const BatterySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: 0.65,
                strokeWidth: 22,
                color: const Color(0xFF2ECC71),
                backgroundColor: const Color(0xFFA8E6A3),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              children: const [
                Text(
                  "65%",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "35 min restantes",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 6),
                Text(
                  "Cargando",
                  style: TextStyle(
                    color: Color(0xFF2ECC71),
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
