import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'pages/map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Notificaciones básicas',
        channelDescription: 'Notificaciones de pago exitoso',
        defaultColor: Colors.green,
        importance: NotificationImportance.High,
      ),
    ],
  );
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const EVApp());
}

class EVApp extends StatelessWidget {
  const EVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WattsUp',
      home: const MapScreen(),
    );
  }
}
