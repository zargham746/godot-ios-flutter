import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IOS Flutter Communcation',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const godotChannel = MethodChannel('dev.com/godot-channel');
  // String batteryLevel = "Waiting...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: getBatteryLevel,
          child: const Text(
            "Run GODOT",
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  Future getBatteryLevel() async {
    // final arguments = {'name': 'IOS'};
    // final String newBatteryLevel =
    await godotChannel.invokeMethod('getgodot');
    // setState(() => batteryLevel = '$newBatteryLevel%');
  }
}
