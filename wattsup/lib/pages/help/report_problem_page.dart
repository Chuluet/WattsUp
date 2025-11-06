import 'package:flutter/material.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? selectedCategory;
  String? selectedCharger;

  final List<String> categories = [
    'Falla técnica',
    'Problema de conexión',
    'Error en el pago',
    'Otro',
  ];

  final List<String> chargers = [
    'Cargador 01',
    'Cargador 02',
    'Cargador 03',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Reportar un problema",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Por favor, completa los siguientes campos para ayudarnos a resolver el problema.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Categoría del problema
            const Text(
              "Categoría del problema",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedCategory,
              items: categories,
              hint: "Selecciona una categoría",
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
            const SizedBox(height: 20),

            // Cargador afectado
            const Text(
              "Cargador afectado",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedCharger,
              items: chargers,
              hint: "Selecciona un cargador",
              onChanged: (value) => setState(() => selectedCharger = value),
            ),
            const SizedBox(height: 20),

            // Descripción del problema
            const Text(
              "Descripción del problema",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Describe brevemente lo ocurrido...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Adjuntar imagen
            const Text(
              "Adjuntar imagen (opcional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Solo visual
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Función visual: adjuntar imagen")),
                );
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón enviar
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Reporte enviado (solo visual)"),
                    ),
                  );
                },
                child: const Text(
                  "Enviar reporte",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para Dropdowns
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint),
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
