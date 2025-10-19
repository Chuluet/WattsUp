import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final String chargerStatus;
  final VoidCallback? onReservationCompleted;

  const ReservationPage({
    super.key,
    required this.chargerStatus,
    this.onReservationCompleted,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  int selectedHours = 0;
  int selectedMinutes = 30; // mínimo 30 min
  final int minDuration = 30; // minutos
  final int maxDuration = 120; // minutos

  @override
  void initState() {
    super.initState();
    // Inicializa la duración mínima
    selectedHours = minDuration ~/ 60;
    selectedMinutes = minDuration % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar cargador'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado del cargador: ${widget.chargerStatus}',
              style: TextStyle(
                color: widget.chargerStatus == 'Libre' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // Fecha
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                'Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Solo se permiten reservas para hoy'),
              enabled: false,
            ),
            const SizedBox(height: 12),

            // Hora de inicio
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                selectedTime == null
                    ? 'Seleccionar hora de inicio'
                    : selectedTime!.format(context),
              ),
              onTap: _selectTime,
            ),
            const SizedBox(height: 20),

            const Text(
              'Duración de la carga (hora:minuto)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Rueda vertical con horas y minutos
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHourWheel(),
                  const SizedBox(width: 8), // más cerca
                  _buildMinuteWheel(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón confirmar
            Center(
              child: ElevatedButton.icon(
                onPressed: _confirmReservation,
                icon: const Icon(Icons.check),
                label: const Text('Confirmar reserva'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  minimumSize: const Size(250, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourWheel() {
    int maxHours = maxDuration ~/ 60; // 2 horas
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedHours = index;
            _adjustMinutesIfNeeded();
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index > maxHours) return null;
            final isSelected = index == selectedHours;
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSelected ? 24 : 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMinuteWheel() {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedMinutes = index;
            _adjustMinutesIfNeeded();
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index > 59) return null;
            final isSelected = index == selectedMinutes;
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSelected ? 24 : 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _adjustMinutesIfNeeded() {
    int totalMinutes = selectedHours * 60 + selectedMinutes;
    if (totalMinutes < minDuration) {
      selectedHours = minDuration ~/ 60;
      selectedMinutes = minDuration % 60;
    }
    if (totalMinutes > maxDuration) {
      selectedHours = maxDuration ~/ 60;
      selectedMinutes = maxDuration % 60;
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      final now = TimeOfDay.now();
      if (picked.hour < now.hour ||
          (picked.hour == now.hour && picked.minute < now.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'No puedes seleccionar una hora anterior a la actual')),
        );
        return;
      }
      setState(() => selectedTime = picked);
    }
  }

  void _confirmReservation() {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una hora de inicio')),
      );
      return;
    }

    final now = DateTime.now();
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    final endDateTime = startDateTime.add(
      Duration(hours: selectedHours, minutes: selectedMinutes),
    );

    if (endDateTime.day != now.day) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('La reserva no puede superar el día actual')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Reserva confirmada: ${selectedTime!.format(context)} por ${selectedHours}h ${selectedMinutes}m ✅'),
      ),
    );

    widget.onReservationCompleted?.call();
    Navigator.pop(context, true);
  }
}
