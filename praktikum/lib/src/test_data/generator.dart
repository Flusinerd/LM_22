import 'dart:ffi';

import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class SensorData {
  String name;
  double delay = 1;
  bool isRunning = true;
  final Function(String) onDataChanged;

  var values = [
    {'"name"': '"x"', '"value"': '"value"'},
    {'"name"': '"y"', '"value"': '"value"'},
    {'"name"': '"z"', '"value"': '"value"'}
  ];

  SensorData({
    required this.name,
    required this.delay,
    required this.onDataChanged,
  }) {
    Timer.periodic(Duration(milliseconds: (delay * 1000).toInt()),
        (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      }
      onDataChanged(getData(timer));
    });
  }

  String getData(Timer timer) {
    String result;
    switch (name) {
      case 'GPS':
        gps();
        result =
            '{"name": "$name", "timestamp": "${DateTime.now()}", "values":$values}';
        break;
      case 'Gyroscope':
        gyroscoping();
        result =
            '{"name": "$name", "timestamp": "${DateTime.now()}", "values":$values}';
        break;
      case 'Accelerometer':
        acceleration();
        result =
            '{"name": "$name", "timestamp": "${DateTime.now()}", "values":$values}';
        break;
      case 'Random Numbers':
        randomNumbers();
        result =
            '{"name": "$name", "timestamp": "${DateTime.now()}", "values":$values}';
        break;
      default:
        result = "Fehler";
        break;
    }
    return result;
  }

  void randomNumbers() {
    values[0] = {
      '"name"': '"x"',
      '"value"': '"${math.Random().nextDouble().toString()}"'
    };
    values[1] = {
      '"name"': '"y"',
      '"value"': '"${math.Random().nextDouble().toString()}"'
    };
    values[2] = {
      '"name"': '"z"',
      '"value"': '"${math.Random().nextDouble().toString()}"'
    };
  }

  void acceleration() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      values[0] = {'"name"': '"x"', '"value"': '"${event.x.toString()}"'};
      values[1] = {'"name"': '"y"', '"value"': '"${event.y.toString()}"'};
      values[2] = {'"name"': '"z"', '"value"': '"${event.z.toString()}"'};
    });
  }

  void gyroscoping() {
    gyroscopeEvents.listen((event) {
      values[0] = {'"name"': '"x"', '"value"': '"${event.x.toString()}"'};
      values[1] = {'"name"': '"y"', '"value"': '"${event.y.toString()}"'};
      values[2] = {'"name"': '"z"', '"value"': '"${event.z.toString()}"'};
    });
  }

  gps() async {
    //check and request permissions, error prevention
    bool serviceEnabled;
    LocationPermission permission;
    Position pos;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // once here, permissions are as needed, so locaction is set

    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    values[0] = {'"name"': '"lat"', '"value"': '"${pos.latitude.toString()}"'};
    values[1] = {
      '"name"': '"long"',
      '"value"': '"${pos.longitude.toString()}"'
    };
    values[2] = {
      '"name"': '"accuracy"',
      '"value"': '"${pos.accuracy.toString()}"'
    };
  }
}
