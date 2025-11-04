import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/status_row.dart';
import '../widgets/action_buttons.dart';
import '../widgets/marker.dart';
import '../widgets/battery_section.dart';
import 'chat_page.dart';
import 'payment_page.dart';
import 'reservation_page.dart';
import 'profile_page.dart';
import 'queue_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _panelController = PanelController();

  bool _isPanelClosed = true;
  bool _showPopup = false;
  Offset _popupPosition = const Offset(0, 0);
  String _selectedChargerStatus = "Libre";

  int availableChargers = 2;
  int occupiedChargers = 1;
  bool hasActiveReservation = false;
  bool isInQueue = false;
  double batteryLevel = 0.65;

  bool inQueue = false;
  int queuePosition = 0;
  int usersInQueue = 0;


  List<String> queue = [];
  String currentUser = "Usuario1";

  // ---------- Lógica principal ----------

  void _onMarkerTap(double left, double top, String estado) {
    setState(() {
      _showPopup = true;
      _popupPosition = Offset(left + 40, top - 60);
      _selectedChargerStatus = estado;
    });
  }

  void _closePopup() => setState(() => _showPopup = false);

  void _onReservationCompleted() {
    setState(() {
      hasActiveReservation = true;
      isInQueue = false; // sale de la fila si tenía una
      batteryLevel = 0.65;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva activa ✅')),
    );
  }

  void _stopCharging() {
    setState(() {
      hasActiveReservation = false;
      batteryLevel = 0.0;
      if (queue.isNotEmpty) {
        final nextUser = queue.removeAt(0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nextUser ahora puede cargar ⚡')),
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carga detenida 🔌')),
    );
  }

  Future<void> _goToReservationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationPage(
          chargerStatus: "Libre",
          onReservationCompleted: _onReservationCompleted,
        ),
      ),
    );
    if (result == true) _onReservationCompleted();
  }

  Future<void> _goToQueuePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueuePage(
          queueLength: queue.length > 0 ? queue.length : 3,
          alreadyInQueue: isInQueue,
          hasActiveReservation: hasActiveReservation,
          onJoinQueue: _joinQueue,
        ),
      ),
    );

    if (result == true) {
      setState(() => isInQueue = true);
    }
  }

  void _joinQueue() {
    if (!queue.contains(currentUser)) {
      setState(() {
        queue.add(currentUser);
        isInQueue = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te uniste a la fila virtual 🕒')),
      );
    }
  }

  void _leaveQueue() {
    setState(() {
      queue.remove(currentUser);
      isInQueue = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saliste de la fila')),
    );
  }

  // ---------- INTERFAZ ----------

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text(
          'WattsUp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isPanelClosed
          ? Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 💬 Botón de chat restaurado
            FloatingActionButton(
              heroTag: 'chat',
              backgroundColor: Colors.blueAccent,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatPage()),
                );
              },
              child: const Icon(Icons.chat, size: 30),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'payment',
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentPage()),
                );
              },
              child: const Icon(Icons.attach_money, size: 44),
            ),
          ],
        ),
      )
          : null,
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 120,
        maxHeight: maxHeight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        backdropEnabled: true,
        onPanelOpened: () => setState(() => _isPanelClosed = false),
        onPanelClosed: () => setState(() => _isPanelClosed = true),
        panelBuilder: (sc) => _buildBottomPanel(sc),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('lib/assets/images/mapa_eia.png',
                  fit: BoxFit.cover),
            ),
            Marker(
              left: 140,
              top: 300,
              color: Colors.green,
              onTap: () => _onMarkerTap(140, 300, "Libre"),
            ),
            Marker(
              left: 180,
              top: 300,
              color: Colors.green,
              onTap: () => _onMarkerTap(180, 300, "Libre"),
            ),
            Marker(
              left: 220,
              top: 300,
              color: Colors.red,
              onTap: () => _onMarkerTap(220, 300, "Ocupado"),
            ),
            if (_showPopup) _buildPopup(),
          ],
        ),
      ),
    );
  }

  Widget _buildPopup() {
    return Positioned(
      left: _popupPosition.dx,
      top: _popupPosition.dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Estado: $_selectedChargerStatus",
                style: TextStyle(
                  color: _selectedChargerStatus == "Libre"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _selectedChargerStatus == "Ocupado"
                    ? _goToQueuePage
                    : (!isInQueue && !hasActiveReservation
                    ? _goToReservationPage
                    : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(_selectedChargerStatus == "Ocupado"
                    ? "Ver fila"
                    : "Reservar"),
              ),
              TextButton(
                onPressed: _closePopup,
                child: const Text("Cerrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: const EdgeInsets.only(top: 60),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title:
            const Text("Ver perfil", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(ScrollController sc) {
    final int estimatedMinutes = (queue.indexOf(currentUser) + 1) * 15;

    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _PanelHandle(),
            const SizedBox(height: 40),
            StatusRow(available: availableChargers, occupied: occupiedChargers),
            const SizedBox(height: 60),
            BatterySection(
              batteryLevel: batteryLevel,
              isActive: hasActiveReservation,
              isWaiting: isInQueue,
              queuePosition: queue.indexOf(currentUser) + 1,
              usersInQueue: queue.isEmpty ? 3 : queue.length,
              remainingMinutes: (queue.indexOf(currentUser) + 1) * 15,
            ),
            const SizedBox(height: 30),
            if (isInQueue) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToQueuePage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Ver fila"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _leaveQueue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Salir de la fila"),
              ),
              const SizedBox(height: 30),
            ],
            ActionButtons(
              hasActiveReservation: hasActiveReservation,
              onStop: hasActiveReservation ? _stopCharging : null,
              onReserve: (!isInQueue && !hasActiveReservation)
                  ? () async {
                await _goToReservationPage();
              }
                  : null,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _PanelHandle extends StatelessWidget {
  const _PanelHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
