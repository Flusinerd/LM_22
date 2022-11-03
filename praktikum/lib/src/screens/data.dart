import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:praktikum/src/sensor_data.dart';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  //setting position to roughly paris as default to avoid errors
  Position _currentPosition = Position(
      longitude: 48.856613,
      latitude: 2.352222,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  //UI
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_currentPosition != null)
            CupertinoButton(
                child: const Text("Get location"),
                onPressed: () {
                  _getCurrentLocation();
                }),
          Text(
              "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}, Accuracy: +/-${_currentPosition.accuracy}m"),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    //check and request permissions, error prevention
    bool serviceEnabled;
    LocationPermission permission;
    Position pos;

    //checking if value
    print(_currentPosition);

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

    // Create sensor_data object for lat and long
    SensorData lat = SensorData(_currentPosition.latitude, DateTime.now(),
        const SensorMetadata("latitude"));
    SensorData lng = SensorData(_currentPosition.longitude, DateTime.now(),
        const SensorMetadata("longitude"));

    // Create array of sensor_data objects
    List<SensorData> sensorData = [lat, lng];

    // Create json string from sensor_data objects
    String json = jsonEncode(sensorData);

    // POST sensor_data to server as JSON
    await http.post(Uri.parse("https://lm.jan-krueger.eu/data"), body: json);
    setState(() {
      _currentPosition = pos;
    });

    //checking value
    print(_currentPosition);
  }
}
