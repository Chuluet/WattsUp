import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Pagos", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Método de pago", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Opciones de pago
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Row(
                children: const [
                  Icon(Icons.credit_card, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Tarjeta de crédito/débito", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.payment, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                children: const [
                  Icon(Icons.badge, color: Colors.grey),
                  SizedBox(width: 10),
                  Text("Carnet estudiantil", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 10),

            const Text("Resumen de la reserva", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.directions_car, color: Colors.black54, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Mini Cooper SE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("15 agosto", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("\$25.000", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Total", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text("Pagar ahora", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar y volver", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
