import 'package:flutter/material.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Contacto y soporte",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _contactCard(
            icon: Icons.email_outlined,
            title: "Correo de soporte",
            subtitle: "soporte@wattsup.com",
          ),
          const Divider(thickness: 0.6, height: 25),
          _contactCard(
            icon: Icons.phone_in_talk_outlined,
            title: "Línea de atención",
            subtitle: "+57 604 444 4115",
          ),
          const Divider(thickness: 0.6, height: 25),
          _contactCard(
            icon: Icons.chat_bubble_outline,
            title: "Chat de ayuda",
            subtitle: "Habla con un asesor disponible",
          ),
          const Divider(thickness: 0.6, height: 25),
          _contactCard(
            icon: Icons.public,
            title: "Centro de ayuda en línea",
            subtitle: "www.wattsup.com/ayuda",
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: const [
                Icon(Icons.support_agent, size: 80, color: Colors.blueGrey),
                SizedBox(height: 10),
                Text(
                  "Nuestro equipo está disponible\nde lunes a viernes, 8 a.m. – 6 p.m.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
