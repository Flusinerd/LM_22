import 'package:flutter/cupertino.dart';
import 'package:praktikum/src/location_service.dart';
import 'package:praktikum/src/model/setting.dart';

class SettingsScreen extends StatefulWidget {
  final Function onDataSend;
  const SettingsScreen({super.key, required this.onDataSend});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final dataGenerators = [];
  var icon = const Icon(CupertinoIcons.play_circle);

  final modes = LocationService().modes;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  final settings = LocationService().settings;

  SettingsScreenState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Build a slider for each setting
          for (var setting in settings)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${setting.name}: ${setting.value} ${setting.unit}"),
                CupertinoSlider(
                  value: setting.value.toDouble(),
                  min: setting.minValue,
                  max: setting.maxValue,
                  divisions: (setting.maxValue - setting.minValue).round(),
                  onChanged: (double value) {
                    setState(() {
                      setting.value = value.round();
                    });
                  },
                ),
              ],
            ),
          // Insert a spacer
          Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 1.0, color: CupertinoColors.systemGrey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Build a select to select the mode
          Row(children: [
            const Text("Modus: "),
            CupertinoButton(
              child: Text(LocationService().getMode()),
              onPressed: () => _showDialog(
                CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: ((value) => {
                        LocationService().setMode(modes[value]),
                      }),
                  children: [for (var mode in modes) Center(child: Text(mode))],
                ),
              ),
            ),
          ]),
          Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 1.0, color: CupertinoColors.systemGrey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Stillstandserkennung"),
              CupertinoSwitch(
                value: LocationService().standStillDetectionEnabled,
                onChanged: (bool value) {
                  setState(() {
                    LocationService().standStillDetectionEnabled = value;
                  });
                },
              ),
            ],
          ),
          Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 1.0, color: CupertinoColors.systemGrey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Daten Sammeln"),
              CupertinoButton(
                child: icon,
                onPressed: () {
                  setState(() {
                    if (LocationService().isRunning) {
                      icon = const Icon(CupertinoIcons.play_circle);
                      LocationService().isRunning = false;
                    } else {
                      icon = const Icon(CupertinoIcons.stop_circle);
                      LocationService().isRunning = true;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
