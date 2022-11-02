import 'dart:ffi';

import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class SensorData {
  String name;
  double delay = 1;
  bool isRunning = true;
  final Function(String) onDataChanged;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  //setting position to roughly paris as default to avoid errors
  Position currentPosition = new Position(
      longitude: 48.856613,
      latitude: 2.352222,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  double test = 0.0;

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
    gps();
    return ('{"name": "${this.name}", "timestamp": "${DateTime.now()}", "value":$test}');
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

    currentPosition = pos;
    test = pos.latitude;
  }
}
