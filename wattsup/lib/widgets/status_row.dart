import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  final int available;
  final int occupied;

  const StatusRow({
    super.key,
    this.available = 0,
    this.occupied = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusIndicator(
          color: Colors.green,
          label: "$available Disponibles",
        ),
        const SizedBox(width: 20),
        _buildStatusIndicator(
          color: Colors.red,
          label: "$occupied Ocupado${occupied != 1 ? 's' : ''}",
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({required Color color, required String label}) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 26), // tamaño original
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24, // tamaño original
          ),
        ),
      ],
    );
  }
}
