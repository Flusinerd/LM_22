import 'package:flutter/material.dart';
import '../model/sensor_setting.dart';
import '../test_data/generator.dart';

class SettingsScreen extends StatefulWidget {
  final Function onDataSend;
  const SettingsScreen({super.key, required this.onDataSend});
  @override
  SettingsScreenState createState() =>
      SettingsScreenState(onDataSend: (String out) {
        onDataSend(out);
      });
}

class SettingsScreenState extends State<SettingsScreen> {
  final dataGenerators = [];
  var icon = const Icon(Icons.play_circle);

  final Function(String) onDataSend;

  final showAll = SensorSetting(title: 'Show all Sensors');
  final sensors = [
    SensorSetting(title: 'Accelerometer'),
    SensorSetting(title: 'Gyroscope'),
    SensorSetting(title: 'GPS'),
    SensorSetting(title: 'Random Numbers'),
  ];

  SettingsScreenState({required this.onDataSend});

  Widget buildCheckbox({
    required SensorSetting sensor,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: sensor.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(sensor.title),
        subtitle: Slider(
            value: sensor.rate,
            min: 0,
            max: 10,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                sensor.rate = value;
              });
            }),
        trailing: Text(sensor.rate.toStringAsFixed(1)),
        isThreeLine: true,
      );

  Widget buildToggleCheckbox1({
    required SensorSetting sensor,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: sensor.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(sensor.title),
      );

  Widget buildSingleCheckbox(SensorSetting sensor) => buildCheckbox(
        sensor: sensor,
        onClicked: () {
          setState(() {
            final newValue = !sensor.value;
            sensor.value = newValue;

            if (!newValue) {
              showAll.value = false;
            } else {
              final all = sensors.every((sensor) => sensor.value);
              showAll.value = all;
            }
          });
        },
      );

  Widget buildToggleCheckbox(SensorSetting sensor) => buildToggleCheckbox1(
        sensor: sensor,
        onClicked: () {
          final newValue = !sensor.value;
          setState(() {
            showAll.value = newValue;
            for (var sensor in sensors) {
              sensor.value = newValue;
            }
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            buildToggleCheckbox(showAll),
            const Divider(),
            ...sensors.map(buildSingleCheckbox).toList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!(dataGenerators.isNotEmpty)) {
              setState(() {
                for (var sensor in sensors) {
                  if (sensor.value) {
                    SensorData test = SensorData(
                      name: sensor.title,
                      delay: sensor.rate,
                      onDataChanged: (String out) {
                        onDataSend(out);
                      },
                    );
                    dataGenerators.add(test);
                    icon = const Icon(Icons.pause_circle);
                  }
                }
              });
            } else {
              for (var dataGenerator in dataGenerators) {
                dataGenerator.isRunning = !dataGenerator.isRunning;
              }
              dataGenerators.clear();
              setState(() {
                icon = const Icon(Icons.play_circle);
              });
            }
          },
          child: icon,
        ),
      ),
    );
  }
}
