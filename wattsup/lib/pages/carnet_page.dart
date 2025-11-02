import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:wattsup/pages/payment_page.dart';
import 'map_page.dart';

class CarnetPaymentPage extends StatefulWidget {
  const CarnetPaymentPage({super.key});

  @override
  State<CarnetPaymentPage> createState() => _CarnetPaymentPageState();
}

class _CarnetPaymentPageState extends State<CarnetPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _showSuccessNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'Pago exitoso 🎓',
        body:
            'Tu reserva ha sido pagada exitosamente con el carnet estudiantil.',
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      counterText: "",
    );
  }

  void _validateAndPay() {
    if (_formKey.currentState!.validate()) {
      _showSuccessNotification();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MapScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Revise que todos los campos sean correctos"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pagar con carnet estudiantil",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputStyle("Nombre"),
                  maxLength: 30,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese el nombre" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _lastNameController,
                  decoration: _inputStyle("Apellido"),
                  maxLength: 30,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese el apellido" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _idController,
                  decoration: _inputStyle("Cédula o ID estudiantil"),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (v) => v == null || v.isEmpty
                      ? "Ingrese su cédula o ID estudiantil"
                      : null,
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _validateAndPay,
                  child: const Text(
                    "Pagar",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Cancelar pago",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
