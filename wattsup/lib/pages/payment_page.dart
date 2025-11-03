import 'package:flutter/material.dart';
import 'package:wattsup/pages/map_page.dart';
import 'credit_card_page.dart';
import 'carnet_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'credit'; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pagos",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Método de pago",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Tarjeta
            GestureDetector(
              onTap: () => setState(() => selectedMethod = 'credit'),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedMethod == 'credit'
                        ? Colors.green
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: selectedMethod == 'credit'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Tarjeta de crédito/débito",
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      color: selectedMethod == 'credit'
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Carnet
            GestureDetector(
              onTap: () => setState(() => selectedMethod = 'carnet'),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedMethod == 'carnet'
                        ? Colors.green
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.badge,
                      color: selectedMethod == 'carnet'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Carnet estudiantil",
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      color: selectedMethod == 'carnet'
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              "Resumen de la reserva",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                  const Icon(
                    Icons.directions_car,
                    color: Colors.black54,
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Mini Cooper SE",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("15 agosto", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$25.000",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Total", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón principal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedMethod == 'credit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditCardPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarnetPaymentPage(),
                    ),
                  );
                }
              },
              child: const Text(
                "Pagar ahora",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MapScreen()),
                    (route) => false,
                  );
                },

                child: const Text(
                  "Cancelar y volver",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
