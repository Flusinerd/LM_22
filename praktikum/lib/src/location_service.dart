import 'package:geolocator/geolocator.dart';
import 'package:praktikum/src/model/setting.dart';
import 'package:praktikum/src/sensor_data.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  LocationService._internal();

  String mode = 'Zeit';
  final settings = [
    Setting(name: "Zeit", unit: "s", minValue: 1, maxValue: 20, value: 0),
    Setting(name: "Distanz ", unit: "m", minValue: 1, maxValue: 50, value: 0),
    Setting(
        name: "Geschwindigkeit",
        unit: "m/s",
        minValue: 1,
        maxValue: 10,
        value: 0),
    Setting(
        name: "Beschleunigung",
        unit: "m/s²",
        minValue: 0,
        maxValue: 20,
        value: 0),
  ];
  final modes = ['Zeit', 'Distanz', 'Geschwindigkeit'];
  bool isRunning = false;
  bool hasPermission = false;
  bool isStandingStill = false;
  bool standStillDetectionEnabled = false;
  bool initDone = false;

  MapLatLng lastSendLocation = const MapLatLng(0, 0);
  MapLatLng currentLocation = const MapLatLng(0, 0);

  factory LocationService() {
    return _instance;
  }

  void setMode(String mode) {
    this.mode = mode;
  }

  String getMode() {
    return mode;
  }

  init() async {
    // Get GPS Permission
    if (!hasPermission) {
      await Geolocator.requestPermission();
    }
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      return;
    }
    hasPermission = true;

    // Listen to accelerometer events
    // Use userAccelerometerEvents to ignore gravity
    userAccelerometerEvents.listen((event) {
      if (event.x.abs() < settings[3].value &&
          event.y.abs() < settings[3].value &&
          event.z.abs() < settings[3].value) {
        isStandingStill = true;
      } else {
        isStandingStill = false;
      }
    });
  }

  run() async {
    if (!initDone) {
      await init();
      initDone = true;
    }

    var intervalTime = 1000;
    if (mode == 'Zeit') {
      intervalTime = settings[0].value * 1000;
    }
    if (mode == 'Geschwindigkeit') {
      var distanz = settings[1].value;
      var geschwindigkeit = settings[2].value;
      intervalTime = ((distanz / geschwindigkeit) * 1000).floor();
    }
    if (mode == 'Distanz') {
      intervalTime = 1000;
    }

    Future.delayed(Duration(milliseconds: intervalTime), () {
      doActions();
      run();
    });
  }

  Future<void> doActions() async {
    if (!isRunning) {
      return;
    }

    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation = MapLatLng(location.latitude, location.longitude);

    if (mode == 'Distanz') {
      // Check if distance is reached
      var distance = Geolocator.distanceBetween(
          lastSendLocation.latitude,
          lastSendLocation.longitude,
          currentLocation.latitude,
          currentLocation.longitude);

      if (distance >= settings[1].value) {
        sendLocation();
        return;
      }
    }

    sendLocation();
  }

  sendLocation() {
    if (standStillDetectionEnabled && isStandingStill) {
      return;
    }

    lastSendLocation = currentLocation;
    SensorData lat = SensorData(currentLocation.latitude, DateTime.now(),
        SensorMetadata("latitude_$mode"));
    SensorData lng = SensorData(currentLocation.longitude, DateTime.now(),
        SensorMetadata("longitude_$mode"));

    // Create array of sensor_data objects
    List<SensorData> sensorData = [lat, lng];

    // Create json string from sensor_data objects
    String json = jsonEncode(sensorData);
    http.post(Uri.parse("https://lm.jan-krueger.eu/data"), body: json);
  }
}
