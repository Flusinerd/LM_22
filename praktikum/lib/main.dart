import 'package:flutter/material.dart';
import 'package:praktikum/src/app.dart';
import 'package:praktikum/src/location_service.dart';

void main() {
  runApp(const DatenkrakeApp());
  LocationService().run();
}
