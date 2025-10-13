import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/status_row.dart';
import '../widgets/battery_icon.dart';
import '../widgets/action_buttons.dart';
import '../widgets/marker.dart';
import 'battery_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 120,
        maxHeight: maxHeight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        parallaxEnabled: true,
        parallaxOffset: 0.2,
        panelBuilder: (sc) => _buildBottomPanel(sc),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('lib/assets/images/mapa_eia.png', fit: BoxFit.cover),
            ),
            const Marker(left: 140, top: 300, color: Colors.green),
            const Marker(left: 180, top: 300, color: Colors.green),
            const Marker(left: 220, top: 300, color: Colors.brown),

            // Menú lateral
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

  Widget _buildBottomPanel(ScrollController sc) {
    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            SizedBox(height: 8),
            _PanelHandle(),
            SizedBox(height: 12),
            StatusRow(),
            SizedBox(height: 20),
            BatteryIcon(),
            SizedBox(height: 40),
            BatterySection(),
            SizedBox(height: 80),
            ActionButtons(),
            SizedBox(height: 40),
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
