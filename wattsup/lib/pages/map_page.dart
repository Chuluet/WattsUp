import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wattsup/pages/config_page.dart';
import 'package:wattsup/pages/help_page.dart';
import '../widgets/status_row.dart';
import '../widgets/action_buttons.dart';
import '../widgets/marker.dart';
import '../widgets/battery_section.dart';
import 'chat_page.dart';
import 'payment_page.dart';
import 'reservation_page.dart';
import 'profile_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _panelController = PanelController();

  // Controladores para el mapa interactivo
  final TransformationController _transformationController = TransformationController();

  bool _isPanelClosed = true;
  bool _showPopup = false;
  Offset _popupPosition = const Offset(0, 0);
  String _selectedChargerStatus = "Libre";

  int availableChargers = 2;
  int occupiedChargers = 1;
  bool hasActiveReservation = false;
  double batteryLevel = 0.65;

  final double _minScale = 0.5;
  final double _maxScale = 3.0;

  // Posiciones de los cargadores
  final List<Map<String, dynamic>> _chargers = [
    {'left': 490.0, 'top': 360.0, 'status': 'Libre'},
    {'left': 530.0, 'top': 360.0, 'status': 'Libre'},
    {'left': 570.0, 'top': 360.0, 'status': 'Ocupado'},
  ];

  // GlobalKey para el Stack que contiene los marcadores
  final GlobalKey _markersStackKey = GlobalKey();

  void _centerOnChargers() {
    _closePopup();
    
    double totalLeft = 0;
    double totalTop = 0;
    
    for (var charger in _chargers) {
      totalLeft += charger['left'] as double;
      totalTop += charger['top'] as double;
    }
    
    double centerLeft = totalLeft / _chargers.length;
    double centerTop = totalTop / _chargers.length;
    
    final screenSize = MediaQuery.of(context).size;
    
    double targetScale = 1.2;
    double translateX = (screenSize.width / 2) - (centerLeft * targetScale);
    double translateY = (screenSize.height / 2) - (centerTop * targetScale);
    
    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(translateX, translateY)
        ..scale(targetScale);
    });
  }

  void _onMarkerTap(double left, double top, String estado) {
    // Obtener el RenderBox del Stack que contiene los marcadores
    final RenderBox? markersBox = _markersStackKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (markersBox != null) {
      // Convertir la posición local del marcador a posición global en la pantalla
      final globalPosition = markersBox.localToGlobal(Offset(left, top));
      
      // Obtener el RenderBox del Stack principal
      final RenderBox? mainStackBox = context.findRenderObject() as RenderBox?;
      
      if (mainStackBox != null) {
        // Convertir la posición global a posición local dentro del Stack principal
        final localPosition = mainStackBox.globalToLocal(globalPosition);
        
        setState(() {
          _showPopup = true;
          // Posicionar el popup arriba del marcador
          _popupPosition = Offset(localPosition.dx - 90, localPosition.dy - 120);
          _selectedChargerStatus = estado;
        });
      }
    }
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reserva activa ✅')));
  }

  void _stopCharging() {
    setState(() {
      hasActiveReservation = false;
      batteryLevel = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carga detenida 🔌')));
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
      appBar: AppBar(
        title: const Text(
          'WattsUp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _centerOnChargers,
            tooltip: 'Centrar en cargadores',
          ),
        ],
      ),
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
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: GestureDetector(
        onTap: _closePopup,
        child: SlidingUpPanel(
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
              // Mapa interactivo
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: _minScale,
                maxScale: _maxScale,
                constrained: false,
                transformationController: _transformationController,
                child: Stack(
                  key: _markersStackKey, // Key para calcular posiciones de marcadores
                  children: [
                    Image.asset(
                      'lib/assets/images/mapa_eia.png',
                      fit: BoxFit.contain,
                    ),
                    // Marcadores
                    ..._chargers.map((charger) => Positioned(
                          left: charger['left'] as double,
                          top: charger['top'] as double,
                          child: Marker(
                            color: charger['status'] == 'Libre' ? Colors.green : Colors.red,
                            onTap: () => _onMarkerTap(
                              charger['left'] as double, 
                              charger['top'] as double, 
                              charger['status'] as String,
                            ),
                          ),
                        )).toList(),
                  ],
                ),
              ),
              // Popup overlay - siempre en la parte superior
              if (_showPopup) 
                _buildPopup(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopup() {
    return Positioned(
      left: _popupPosition.dx,
      top: _popupPosition.dy,
      child: GestureDetector(
        onTap: () {}, // Evita que el tap se propague al GestureDetector padre
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
                    color: _selectedChargerStatus == "Libre"
                        ? Colors.green
                        : Colors.red,
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
                TextButton(onPressed: _closePopup, child: const Text("Cerrar")),
              ],
            ),
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
            title: const Text(
              "Ver perfil",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              "Configuración",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: const Text(
              "Ayuda",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(ScrollController sc, BuildContext context) {
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
            ),
            const SizedBox(height: 50),
            ActionButtons(
              hasActiveReservation: hasActiveReservation,
              onStop: hasActiveReservation ? _stopCharging : null,
              onReserve: _goToReservationPage,
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 24),
              label: const Text("Abrir chat", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 60),
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