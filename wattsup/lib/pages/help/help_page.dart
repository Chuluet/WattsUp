import 'package:flutter/material.dart';
import 'package:wattsup/pages/help/report_problem_page.dart';
import 'faq_page.dart';
import 'guide_page.dart';
import 'support_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _faqExpanded = false;
  bool _guideExpanded = false;

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

          // 🔹 Sección Preguntas frecuentes (desplegable)
          _buildExpandableSection(
            title: "Preguntas frecuentes",
            expanded: _faqExpanded,
            onToggle: () => setState(() => _faqExpanded = !_faqExpanded),
            child: const FAQContent(), // Cambiado a FAQContent
          ),

          const Divider(thickness: 0.5, height: 1, color: Colors.grey),

          // 🔹 Sección Guías rápidas (desplegable)
          _buildExpandableSection(
            title: "Guías rápidas",
            expanded: _guideExpanded,
            onToggle: () => setState(() => _guideExpanded = !_guideExpanded),
            child: const GuideContent(), // Cambiado a GuideContent
          ),

          const Divider(thickness: 0.5, height: 1, color: Colors.grey),

          // 🔹 Contacto y soporte
          _buildOption(context, "Contacto y soporte", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactSupportPage(),
              ),
            );
          }),

          const Divider(thickness: 0.5, height: 1, color: Colors.grey),

          // 🔹 Reportar un problema
          _buildOption(context, "Reportar un problema", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportProblemPage(),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 🔸 Widget desplegable (mantiene el contenido visible al expandir)
  Widget _buildExpandableSection({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: child,
          ),
      ],
    );
  }

  // 🔸 Opción normal (navegable)
  Widget _buildOption(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}