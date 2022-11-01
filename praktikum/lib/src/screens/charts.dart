import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class ChartsScreen extends StatefulWidget {
  _ChartsScreenState createState() => _ChartsScreenState();
}

class TestData {
  TestData(this.time, this.value);
  final DateTime time;
  final double value;
}

class _ChartsScreenState extends State<ChartsScreen> {
  bool _isRunning = true;

  void initState() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isRunning) {
        timer.cancel();
      }
      updateDataSource(timer);
    });
    super.initState();
  }

  late ChartSeriesController _chartSeriesController;

  List<TestData> _chartData = [];

  /*List<TestData> _chartData2 = [
    TestData(1, 28),
    TestData(2, 30),
    TestData(3, 15),
    TestData(4, 9),
    TestData(5, 18)
  ];*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          title: ChartTitle(text: _isRunning.toString()),
          legend: Legend(isVisible: true),
          series: <ChartSeries>[
            LineSeries<TestData, DateTime>(
                name: 'Test Daten - Später der genaue Sensor',
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: _chartData,
                xValueMapper: (TestData data, _) => data.time,
                yValueMapper: (TestData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
            /*LineSeries<TestData, double>(
                name: 'Test Daten - Ein zweiter Sensor',
                dataSource: _chartData2,
                xValueMapper: (TestData data, _) => data.time,
                yValueMapper: (TestData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(isVisible: true))*/
          ],
          primaryXAxis: DateTimeAxis(
              //minimum: DateTime.now(),
              edgeLabelPlacement: EdgeLabelPlacement.shift),
        ),
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

  double time = 0;
  void updateDataSource(Timer timer) {
    final DateTime now = DateTime.now();
    if (_chartData.length < 30) {
      _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
      _chartSeriesController.updateDataSource(
        addedDataIndex: _chartData.length - 1,
      );
    } else {
      _chartData.add(TestData(now, (math.Random().nextDouble() * 50)));
      _chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
          addedDataIndex: _chartData.length - 1, removedDataIndex: 0);
    }
  }
}
