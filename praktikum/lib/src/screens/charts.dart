import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';

class ChartsScreen extends StatefulWidget {
  ChartsScreen({Key? key}) : super(key: key);

  ChartsScreenState createState() => ChartsScreenState();
}

class TestData {
  TestData(this.time, this.values);
  final DateTime time;
  final List<Tag> values;
}

class Sensor {
  Sensor(this.name, this.data, /*this.lines*/);
  final String name;
  final List<TestData> data;
  //final List<LineSeries> lines;
}

class ChartsScreenState extends State<ChartsScreen> {
  late ChartSeriesController _chartSeriesController;

  List<Sensor> _sensors = [];
  //List<TestData> _chartData = [];
  List<LineSeries> _lines = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          title: ChartTitle(text: 'Chart'),
          legend: Legend(isVisible: true),
          series: <ChartSeries>[
            /*LineSeries<TestData, DateTime>(
                name: 'Test Daten - Später der genaue Sensor',
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: _chartData,
                xValueMapper: (TestData data, _) => data.time,
                yValueMapper: (TestData data, _) => data.values[0].value,
                dataLabelSettings: DataLabelSettings(isVisible: true)),*/
            ..._lines,
          ],
          primaryXAxis: DateTimeAxis(
              //minimum: DateTime.now(),
              edgeLabelPlacement: EdgeLabelPlacement.shift),
        ),
      ),
    );
  }

  void updateData(String out) {
    final parsedData = jsonDecode(out);
    // print(parsedData);
    var tagObjsJson = (parsedData['values'] ?? []) as List;
    List<Tag> tagObjs =
        tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();
    //print(tagObjs);
    setState(() {
      int atIndex = -1;

      for (int i = 0; i < _sensors.length; i++) {
        if (_sensors[i].name == parsedData['name']) {
          atIndex = i;
          break;
        }
      }

      if (atIndex == -1) {
        _sensors.add(Sensor(parsedData['name'], []));
        atIndex = _sensors.length - 1;
        for (int i = 0; i < tagObjs.length; i++) {
          _lines.add(LineSeries<TestData, DateTime>(
                name: _sensors[atIndex].name + ' ' + tagObjs[i].name,
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: _sensors[atIndex].data,
                xValueMapper: (TestData data, _) => data.time,
                yValueMapper: (TestData data, _) => data.values[i].value,
                //dataLabelSettings: DataLabelSettings(isVisible: true)),
              ));
        }
      }

      _sensors[atIndex]
          .data
          .add(TestData(DateTime.parse(parsedData['timestamp']), tagObjs));

      /*_chartSeriesController.updateDataSource(
        addedDataIndex: _sensors[atIndex].data.length - 1,
      );*/

      /*if (_chartData.length < 20) {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), tagObjs));
        );        _chartSeriesController.updateDataSource(
          addedDataIndex: _chartData.length - 1,
        );
      } else {
        _chartData.add(TestData(parsedData['name'],
            DateTime.parse(parsedData['timestamp']), tagObjs));
        _chartData.removeAt(0);
        _chartSeriesController.updateDataSource(
            addedDataIndex: _chartData.length - 1, removedDataIndex: 0);
      }*/
    });
  }
}

class Tag {
  late String name;
  late double value;

  Tag(name, value) {
    this.name = name;
    try {
      this.value = double.parse(value);
    } catch (FormatException) {
      print(value);
      this.value = 0.0;
    }
  }

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['value'] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.value} }';
  }
}
