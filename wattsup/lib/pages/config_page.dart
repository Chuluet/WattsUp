import 'package:flutter/material.dart';
import 'help_page.dart'; // Importa la pantalla de ayuda

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Configuración",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const Divider(thickness: 1, height: 1),

          // Sección 1
          _buildOption(context, "Mi perfil", () {}),
          _buildOption(context, "Pagos", () {}),

          const Divider(thickness: 6, color: Color(0xFFE0E0E0)),

          // Sección 2
          _buildOption(context, "Privacidad", () {}),
          _buildOption(context, "Notificaciones", () {}),
          _buildOption(context, "Ayuda", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpPage()),
            );
          }),
          _buildOption(context, "Cerrar sesión", () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
