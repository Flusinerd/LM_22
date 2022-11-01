import 'package:flutter/material.dart';
import '../model/sensor_setting.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final showAll = SensorSetting(title: 'Show all Sensors');
  final sensors = [
    SensorSetting(title: 'Accelerometer'),
    SensorSetting(title: 'Gyroscope'),
    SensorSetting(title: 'GPS'),
  ];

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
    return Scaffold(
      body: ListView(
        children: [
          buildToggleCheckbox(showAll),
          Divider(),
          ...sensors.map(buildSingleCheckbox).toList(),
        ],
      ),
    );
  }
}
