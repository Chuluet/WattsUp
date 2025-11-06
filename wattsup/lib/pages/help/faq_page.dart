import 'package:flutter/material.dart';
import 'package:wattsup/widgets/faq_items.dart';

class FAQContent extends StatelessWidget {
  const FAQContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FAQItem(
          question: "¿Dónde puedo ver mis reservas anteriores?",
          answer:
              "En el menú principal selecciona 'Historial'. Ahí verás todas tus reservas y detalles.",
        ),
        Divider(thickness: 0.5, color: Colors.grey),
        FAQItem(
          question: "¿Cómo contacto al soporte técnico?",
          answer:
              "Ve a 'Ayuda' y selecciona la opción 'Contacto y soporte' para comunicarte con nosotros.",
        ),
        Divider(thickness: 0.5, color: Colors.grey),
        FAQItem(
          question: "¿Qué hago si el cargador no funciona?",
          answer:
              "Detén la carga desde la app y selecciona 'Reportar un problema' en el menú de ayuda.",
        ),
      ],
    );
  }
}