import 'package:flutter/material.dart';
import 'package:wattsup/widgets/guide_items.dart';

class GuideContent extends StatelessWidget {
  const GuideContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GuideItem(
          title:
              "Cómo usar los cargadores eléctricos públicos de EPM (guía paso a paso)",
        ),
        Divider(thickness: 0.5, color: Colors.grey),
        GuideItem(
          title:
              "Instalación de un cargador en casa (guía práctica básica)",
        ),
        Divider(thickness: 0.5, color: Colors.grey),
        GuideItem(
          title:
              "Beneficios de la movilidad eléctrica en Antioquia y Colombia",
        ),
        Divider(thickness: 0.5, color: Colors.grey),
        GuideItem(
          title: "Video: cómo cargar tu vehículo eléctrico paso a paso",
        ),
      ],
    );
  }
}