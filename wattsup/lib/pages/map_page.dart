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
import 'config_page.dart';
import 'help_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _panelController = PanelController();
  final TransformationController _transformationController = TransformationController();
  final GlobalKey _markersStackKey = GlobalKey();

  bool _showPopup = false;
  Offset _popupPosition = const Offset(0, 0);
  String _selectedChargerStatus = "Libre";

  int availableChargers = 2;
  int occupiedChargers = 1;
  bool hasActiveReservation = false;
  bool isInQueue = false;
  double batteryLevel = 0.65;
  List<String> queue = [];
  String currentUser = "Usuario1";

  final List<Map<String, dynamic>> chargers = [
    {'left': 490.0, 'top': 360.0, 'status': 'Libre'},
    {'left': 530.0, 'top': 360.0, 'status': 'Libre'},
    {'left': 570.0, 'top': 360.0, 'status': 'Ocupado'},
  ];

  void _centerOnChargers() {
    double avgX = chargers.fold<double>(0.0, (s, e) => s + e['left']) / chargers.length;
    double avgY = chargers.fold<double>(0.0, (s, e) => s + e['top']) / chargers.length;

    final size = MediaQuery.of(context).size;
    double scale = 1.2;
    double dx = (size.width / 2) - (avgX * scale);
    double dy = (size.height / 2) - (avgY * scale);

    _transformationController.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);
  }

  void _openPopup(double left, double top, String status) {
    final markersBox = _markersStackKey.currentContext?.findRenderObject() as RenderBox?;
    final mainBox = context.findRenderObject() as RenderBox?;

    if (markersBox == null || mainBox == null) return;

    final local = markersBox.localToGlobal(Offset(left, top));
    final pos = mainBox.globalToLocal(local);

    setState(() {
      _selectedChargerStatus = status;
      _popupPosition = Offset(pos.dx - 90, pos.dy - 120);
      _showPopup = true;
    });
  }

  void _closePopup() => setState(() => _showPopup = false);

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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saliste de la fila')));
  }

  Future<void> _goToReservationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationPage(
          chargerStatus: "Libre",
          onReservationCompleted: () =>
              setState(() => hasActiveReservation = true),
        ),
      ),
    );
    if (result == true) setState(() => hasActiveReservation = true);
  }

  Future<void> _goToQueuePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueuePage(
          queueLength: queue.isEmpty ? 3 : queue.length,
          alreadyInQueue: isInQueue,
          hasActiveReservation: hasActiveReservation,
          onJoinQueue: _joinQueue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text("WattsUp", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _centerOnChargers,
          ),
        ],
      ),

      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 120,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        backdropEnabled: true,
        panelBuilder: (sc) => _buildBottomPanel(sc),

        body: Stack(
          children: [
            GestureDetector(
              onTap: _closePopup,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                transformationController: _transformationController,
                child: Stack(
                  key: _markersStackKey,
                  children: [
                    Image.asset(
                      'lib/assets/images/mapa_eia.png',
                      fit: BoxFit.contain,
                    ),
                    ...chargers.map((c) => Positioned(
                      left: c['left'],
                      top: c['top'],
                      child: Marker(
                        color: c['status'] == "Libre" ? Colors.green : Colors.red,
                        onTap: () => _openPopup(c['left'], c['top'], c['status']),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            if (_showPopup) _buildPopup(),

            // ✅ BOTONES FLOTANTES SIEMPRE VISIBLES
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "chatBtn",
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage()));
                    },
                    child: const Icon(Icons.chat),
                  ),
                  const SizedBox(height: 15),
                  FloatingActionButton(
                    heroTag: "payBtn",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage()));
                    },
                    child: const Icon(Icons.payment),
                  ),
                ],
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectedChargerStatus == "Ocupado"
                    ? _goToQueuePage
                    : _goToReservationPage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(_selectedChargerStatus == "Ocupado"
                    ? "Ver fila"
                    : "Reservar"),
              ),
              TextButton(onPressed: _closePopup, child: const Text("Cerrar")),
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
            title: const Text("Ver perfil", style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text("Configuración", style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigPage())),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: const Text("Ayuda", style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(ScrollController sc) {
    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StatusRow(available: availableChargers, occupied: occupiedChargers),
            const SizedBox(height: 50),
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
              ElevatedButton(
                onPressed: _goToQueuePage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Ver fila"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _leaveQueue,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Salir de la fila"),
              ),
              const SizedBox(height: 20),
            ],

            ActionButtons(
              hasActiveReservation: hasActiveReservation,
              onStop: hasActiveReservation
                  ? () => setState(() => hasActiveReservation = false)
                  : null,
              onReserve: (!isInQueue && !hasActiveReservation)
                  ? _goToReservationPage
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
