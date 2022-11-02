import 'dart:ffi';

import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class SensorData {
  String name;
  double delay = 1;
  bool isRunning = true;
  final Function(String) onDataChanged;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  SensorData({
    required this.name,
    required this.delay,
    required this.onDataChanged,
  }) {
    Timer.periodic(Duration(milliseconds: (this.delay * 1000).toInt()),
        (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      }
      onDataChanged(getData(timer));
    });
  }

  String getData(Timer timer) {
    gyroscoping();
    return ('{"name": "${this.name}", "timestamp": "${DateTime.now()}", "value":$x}');
  }

  void acceleration() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      x = event.x;
      y = event.y;
      z = event.z;
    });
  }

  void gyroscoping() {
    gyroscopeEvents.listen((event) {
      x = event.x;
      y = event.y;
      z = event.z;
    });
  }
}
