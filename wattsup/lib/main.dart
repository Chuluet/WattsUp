import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(const EVApp());
}

class EVApp extends StatelessWidget {
  const EVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WattsUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MapScreen(),
    );
  }
}

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Ver perfil", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.white),
              title: const Text("Pagos", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("Ajustes", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text("Ayuda", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.85;

          // The SlidingUpPanel provides a `body` which will be the content
          // beneath the panel. That allows the panel to slide over (cover)
          // the background image when expanded.
          return SlidingUpPanel(
            controller: _panelController,
            minHeight: 120,
            maxHeight: maxHeight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            // Optional: dim background when panel is open
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            // Parallax makes the background move slightly for depth
            parallaxEnabled: true,
            parallaxOffset: 0.2,
            panelBuilder: (sc) => _buildBottomPanelWithScroll(sc),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'lib/assets/images/mapa_eia.png',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  left: 140,
                  top: 300,
                  child: _buildMarker(Colors.green),
                ),
                Positioned(
                  left: 180,
                  top: 300,
                  child: _buildMarker(Colors.green),
                ),
                Positioned(
                  left: 220,
                  top: 300,
                  child: _buildMarker(Colors.brown),
                ),

                /// Menú lateral (ícono)
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
          );
        },
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Column(
      children: [
        Icon(Icons.place, color: color, size: 40),
      ],
    );
  }

  // Provide a panel that integrates with the SlidingUpPanel's internal
  // scroll controller so drag gestures and inner scrolling cooperate.
  Widget _buildBottomPanelWithScroll(ScrollController sc) {
    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Small drag handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status row (icons + labels)
                _buildStatusRow(),
              ],
            ),
            const SizedBox(height: 20),
            // Battery section (big indicator + texts)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _batteryIcon()
              ],
            ),
            const SizedBox(height: 40),
            _buildBatterySection(),
            const SizedBox(height: 80),
            // Action buttons
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


      Widget _buildStatusRow() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.circle, color: Colors.green, size: 30),
            SizedBox(width: 6),
            Text("2 disponibles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
            SizedBox(width: 20),
            Icon(Icons.circle, color: Colors.red, size: 30),
            SizedBox(width: 6),
            Text("1 ocupado", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        );
      }
      Widget _batteryIcon(){
        return Row(
          children: [
            const Icon(Icons.battery_full, color: Colors.green, size: 30),
            const Text("Mi carga", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
          ],
        );
      }

      Widget _buildBatterySection() {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: 0.65,
              strokeWidth: 22,
              color: Colors.green,
              backgroundColor: const Color(0xFFA8E6A3),
              strokeCap: StrokeCap.round, // 🔹 bordes redondeados
            ),
          ),
          Column(
            children: const [
              Text(
                "65%",
                style: TextStyle(
                  fontSize: 40, // 🔹 más grande
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "35 min restantes",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18, // 🔹 texto más legible
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Cargando",
                style: TextStyle(
                  color:Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // 🔹 más grande
                ),
              ),
            ],
          )
        ],
      ),
    ],
  );
}


      Widget _buildActionButtons() {
        return Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 242, 242),
                foregroundColor: Colors.black,
                minimumSize: const Size(260, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.stop, size: 24),
              label: const Text("Detener carga", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 242, 242),
                foregroundColor: Colors.red,
                minimumSize: const Size(260, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.cancel, size: 24),
              label: const Text("Cancelar reserva", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      }
