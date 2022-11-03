import 'package:flutter/material.dart';
import '../model/sensor_setting.dart';
import '../test_data/generator.dart';

class SettingsScreen extends StatefulWidget {
  final Function onDataSend;
  SettingsScreen({required this.onDataSend});
  _SettingsScreenState createState() =>
      _SettingsScreenState(onDataSend: (String out) {
        onDataSend(out);
      });
}

class _SettingsScreenState extends State<SettingsScreen> {
  final dataGenerators = [];

  final Function(String) onDataSend;

  final showAll = SensorSetting(title: 'Show all Sensors');
  final sensors = [
    SensorSetting(title: 'Accelerometer'),
    SensorSetting(title: 'Gyroscope'),
    SensorSetting(title: 'GPS'),
  ];

  _SettingsScreenState({required this.onDataSend});

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
            max: 5,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                sensor.rate = value;
              });
            }),
        trailing: Text(sensor.rate.toString()),
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
            sensors.forEach((sensor) {
              sensor.value = newValue;
            });
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
            Divider(),
            ...sensors.map(buildSingleCheckbox).toList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!(dataGenerators.length > 0)) {
              setState(() {
                sensors.forEach((sensor) {
                  if (sensor.value) {
                    SensorData test = new SensorData(
                      name: sensor.title,
                      delay: sensor.rate,
                      onDataChanged: (String out) {
                        onDataSend(out);
                      },
                    );
                    dataGenerators.add(test);
                  }
                });
              });
            } else {
              dataGenerators.forEach((dataGenerator) {
                dataGenerator.isRunning = !dataGenerator.isRunning;
              });
              dataGenerators.clear();
            }
          },
          child: const Icon(Icons.play_circle),
        ),
      ),
    );
  }
}
