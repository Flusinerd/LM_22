import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math' as math;

class ListScreen extends StatefulWidget {
  _ListScreenState createState() => _ListScreenState();
}

class TestData {
  TestData(this.time, this.value);
  final DateTime time;
  final double value;
}

class _ListScreenState extends State<ListScreen> {
  bool _isRunning = true;

  void initState() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isRunning) {
        timer.cancel();
      }
      _addItem(timer);
    });
    super.initState();
  }

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
                  title: Text('Sensor: ' + _chartData[index].value.toString()),
                  subtitle: Text('Time: ' + _chartData[index].time.toString()),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isRunning = !_isRunning;
            });
          },
          child: const Icon(Icons.stop_circle),
        ),
      ),
    );
  }

  void _addItem(Timer timer) {
    final DateTime now = DateTime.now();
    setState(() {
      if (_chartData.length < 7) {
        _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
      } else {
        _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
        _chartData.removeAt(0);
      }
    });
  }
}
