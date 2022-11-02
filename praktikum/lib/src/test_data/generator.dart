import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:math' as math;

class SensorData {
  String name;
  double delay = 1;
  bool isRunning = true;
  final Function(String) onDataChanged;

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
    return ('{"name": "${this.name}", "timestamp": "${DateTime.now()}", "values":[{"name": "x", "value": ${(math.Random().nextDouble() * 50)}}, {"name": "y", "value": ${(math.Random().nextDouble() * 50)}}, {"name": "z", "value": ${(math.Random().nextDouble() * 50)}}]}');
  }
}
