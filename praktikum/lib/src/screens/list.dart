import 'package:flutter/material.dart';
import 'dart:convert';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  ListScreenState createState() => ListScreenState();
}

class TestData {
  TestData(this.sensor, this.time, this.values);
  final String sensor;
  final DateTime time;
  final List<Tag> values;
}

class ListScreenState extends State<ListScreen> {
  final List<TestData> _chartData = [];

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
                  title: Text(
                      '${_chartData[index].sensor}: ${_chartData[index].values}'),
                  subtitle: Text('Time: ${_chartData[index].time}'),
                ),
              );
            }),
      ),
    );
  }

  void updateData(String out) {
    //print(out);
    final parsedData = jsonDecode(out);
    var tagObjsJson = (parsedData['values'] ?? []) as List;
    List<Tag> tagObjs =
        tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();
    //print(tagObjs);
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
  String value;

  Tag(this.name, this.value);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['value'] as String);
  }

  @override
  String toString() {
    // ignore: unnecessary_brace_in_string_interps
    return ' $name: $value ';
  }
}
