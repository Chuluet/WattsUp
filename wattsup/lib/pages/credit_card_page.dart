import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wattsup/pages/payment_page.dart';
import 'map_page.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({super.key});

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final _formKey = GlobalKey<FormState>();
  final cardController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void dispose() {
    cardController.dispose();
    nameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _showSuccessNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Pago exitoso 💳',
        body: 'Tu reserva ha sido pagada exitosamente.',
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
      counterText: "", // oculta el contador visual
    );
  }

  void _formatCardNumber(String value) {
    value = value.replaceAll(RegExp(r'\s+'), '');
    final newValue = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i % 4 == 0 && i != 0) newValue.write(' ');
      newValue.write(value[i]);
    }
    cardController.value = TextEditingValue(
      text: newValue.toString(),
      selection: TextSelection.collapsed(offset: newValue.length),
    );
  }

  void _formatExpiry(String value) {
    value = value.replaceAll('/', '');
    if (value.length > 4) value = value.substring(0, 4);
    if (value.length >= 3) {
      value = value.substring(0, 2) + '/' + value.substring(2);
    }
    expiryController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  bool _isValidExpiry(String text) {
    final expReg = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    return expReg.hasMatch(text);
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
          content: Text('Revise que todos los campos sean correctos'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pagar con tarjeta"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cardController,
                decoration: _inputStyle("Número de tarjeta"),
                keyboardType: TextInputType.number,
                onChanged: _formatCardNumber,
                maxLength: 19,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                validator: (value) {
                  if (value == null || value.replaceAll(' ', '').length < 16) {
                    return "Ingrese un número de tarjeta válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                decoration: _inputStyle("Nombre en la tarjeta"),
                maxLength: 30,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryController,
                      decoration: _inputStyle("Fecha (MM/AA)"),
                      keyboardType: TextInputType.number,
                      onChanged: _formatExpiry,
                      maxLength: 5,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (value) {
                        if (value == null || !_isValidExpiry(value)) {
                          return "Formato inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: cvvController,
                      decoration: _inputStyle("CVV"),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (value) {
                        if (value == null || value.length != 3) {
                          return "CVV inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
                child:
                    const Text("Pagar", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentPage()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Cancelar pago",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
