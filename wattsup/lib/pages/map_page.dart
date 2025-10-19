import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/status_row.dart';
import '../widgets/action_buttons.dart';
import '../widgets/marker.dart';
import '../widgets/battery_section.dart'; // <-- Importamos el círculo
import 'chat_page.dart';
import 'payment_page.dart';
import 'reservation_page.dart';

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

  // Variables dinámicas
  int availableChargers = 2;
  int occupiedChargers = 1;
  bool hasActiveReservation = false;
  double batteryLevel = 0.65;

  void _onMarkerTap(double left, double top, String estado) {
    setState(() {
      _showPopup = true;
      _popupPosition = Offset(left + 40, top - 60);
      _selectedChargerStatus = estado;
    });
  }

  void _closePopup() {
    setState(() {
      _showPopup = false;
    });
  }

  void _onReservationCompleted() {
    setState(() {
      hasActiveReservation = true;
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
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carga detenida 🔌')),
    );
  }

  void _cancelReservation() {
    setState(() {
      hasActiveReservation = false;
      batteryLevel = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva cancelada ❌')),
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

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: _isPanelClosed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: _isPanelClosed
            ? Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: SizedBox(
            width: 80,
            height: 80,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              child: const Icon(Icons.attach_money, color: Colors.white, size: 44),
            ),
          ),
        )
            : null,
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 120,
        maxHeight: maxHeight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        parallaxEnabled: true,
        parallaxOffset: 0.2,
        onPanelOpened: () => setState(() => _isPanelClosed = false),
        onPanelClosed: () => setState(() => _isPanelClosed = true),
        panelBuilder: (sc) => _buildBottomPanel(sc, context),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('lib/assets/images/mapa_eia.png', fit: BoxFit.cover),
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
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
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
          width: 180,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Estado: $_selectedChargerStatus",
                style: TextStyle(
                  color: _selectedChargerStatus == "Libre" ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _selectedChargerStatus == "Ocupado"
                    ? null
                    : () {
                  _goToReservationPage();
                  _closePopup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Reservar"),
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
        children: const [
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Ver perfil", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.white),
            title: Text("Pagos", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Ajustes", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.white),
            title: Text("Ayuda", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(ScrollController sc, BuildContext context) {
    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _PanelHandle(),
            const SizedBox(height: 12),
            StatusRow(
              available: availableChargers,
              occupied: occupiedChargers,
            ),
            const SizedBox(height: 20),

            // Círculo de carga
            BatterySection(
              batteryLevel: batteryLevel,
              isActive: hasActiveReservation,
            ),

            const SizedBox(height: 40),
            ActionButtons(
              hasActiveReservation: hasActiveReservation,
              onStop: hasActiveReservation ? _stopCharging : null,

              onReserve: _goToReservationPage,
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Abrir chat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 40),
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
