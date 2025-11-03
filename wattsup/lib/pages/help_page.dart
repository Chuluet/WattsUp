import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool showFAQ = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Ayuda",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const Divider(thickness: 1, height: 1),

          // 🔽 Preguntas Frecuentes con menú desplegable
          InkWell(
            onTap: () => setState(() => showFAQ = !showFAQ),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Preguntas Frecuentes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    showFAQ ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Contenido desplegable
          if (showFAQ)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _FAQItem(
                    question: "¿Dónde puedo ver mis reservas anteriores?",
                    answer:
                        "En el menú principal selecciona 'Historial'. Ahí verás todas tus reservas y detalles.",
                  ),
                  Divider(thickness: 0.5, color: Colors.grey),
                  _FAQItem(
                    question: "¿Cómo contacto al soporte técnico?",
                    answer:
                        "Ve a 'Ayuda' y selecciona la opción 'Contacto y soporte' para comunicarte con nosotros.",
                  ),
                  Divider(thickness: 0.5, color: Colors.grey),
                  _FAQItem(
                    question: "¿Qué hago si el cargador no funciona?",
                    answer:
                        "Detén la carga desde la app y selecciona 'Reportar un problema' en el menú de ayuda.",
                  ),
                ],
              ),
            ),

          const Divider(thickness: 0.5, height: 1, color: Colors.grey),

          // Resto de opciones
          _buildOption(context, "Guías rápidas", () {}),
          const Divider(thickness: 0.5, height: 1, color: Colors.grey),
          _buildOption(context, "Contacto y soporte", () {}),
          const Divider(thickness: 0.5, height: 1, color: Colors.grey),
          _buildOption(context, "Reportar un problema", () {
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

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
