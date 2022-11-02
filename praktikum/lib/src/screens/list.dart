import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';

import '../test_data/generator.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  ListScreenState createState() => ListScreenState();
}

class TestData {
  TestData(this.sensor, this.time, this.values);
  final String sensor;
  final DateTime time;
  final List<Tag> values;
}

class ListScreenState extends State<ListScreen> {
  bool _isRunning = true;

  List<TestData> _chartData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
            itemCount: _chartData.length,
            itemBuilder: (_, index) {
              return Card(
                margin: const EdgeInsets.all(5),
                elevation: 5,
                child: ListTile(
                  title: Text(_chartData[index].sensor +
                      ': ' +
                      _chartData[index].values.toString()),
                  subtitle: Text('Time: ' + _chartData[index].time.toString()),
                ),
              );
            }),
      ),
    );
  }

  void updateData(String out) {
    final parsedData = jsonDecode(out);
    var tagObjsJson = (parsedData['values'] ?? []) as List;
    List<Tag> tagObjs =
        tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();
    print(tagObjs);
    setState(() {
      if (_chartData.length < 7) {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), tagObjs));
      } else {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), tagObjs));
        _chartData.removeAt(0);
      }
    });
  }
}

class Tag {
  String name;
  double value;

  Tag(this.name, this.value);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['value'] as double);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.value} }';
  }
}
