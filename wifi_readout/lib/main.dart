import 'dart:developer';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wifi Readout"),
        ),
        body: const Center(
          child: WifiReadoutWidget(),
        ),
      ),
    );
  }
}

class WifiReadoutWidget extends StatefulWidget {
  const WifiReadoutWidget({super.key});

  @override
  State<WifiReadoutWidget> createState() => _WifiReadoutWidgetState();
}

class _WifiReadoutWidgetState extends State<WifiReadoutWidget> {
  static const platform = MethodChannel('de.hs-bochum/wifi');

  Future<void> _getWifiLevel() async {
    try {
      final result = await platform.invokeMapMethod('getWifiStrength');
      final text = Text(
        "Signal Strength: ${result!['signalStrength']}\nSSID: ${result['ssid']}\nFrequency: ${result['frequency']}",
      );
      final snackBar = SnackBar(content: text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      log("Error", error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Wifi Status"),
        ElevatedButton(
          onPressed: _getWifiLevel,
          child: const Text("Get Status"),
        )
      ],
    );
  }
}

class WifiInfo {
  int? signalStrength;
  String? ssid;
  int? frequency;
}
