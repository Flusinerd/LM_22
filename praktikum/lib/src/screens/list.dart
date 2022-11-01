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
  TestData(this.sensor, this.time, this.value);
  final String sensor;
  final DateTime time;
  final double value;
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
                      _chartData[index].value.toString()),
                  subtitle: Text('Time: ' + _chartData[index].time.toString()),
                ),
              );
            }),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isRunning = !_isRunning;
            });
          },
          child: const Icon(Icons.stop_circle),
        ),*/
      ),
    );
  }

  /* void _addItem(Timer timer) {
    final DateTime now = DateTime.now();
    setState(() {
      if (_chartData.length < 7) {
        _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
      } else {
        _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
        _chartData.removeAt(0);
      }
    });
  }*/

  void updateData(String out) {
    final parsedData = jsonDecode(out);
    //print(parsedData['timestamp']);
    setState(() {
      if (_chartData.length < 7) {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), parsedData['value']));
      } else {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), parsedData['value']));
        _chartData.removeAt(0);
      }
    });
  }
}
