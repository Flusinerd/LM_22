import 'package:flutter/cupertino.dart';
import 'package:praktikum/src/widgets/tabbar.dart';

class DatenkrakeApp extends StatefulWidget {
  const DatenkrakeApp({super.key});

  @override
  DatenkrakeAppState createState() => DatenkrakeAppState();
}

class DatenkrakeAppState extends State<DatenkrakeApp>
    with WidgetsBindingObserver {
  Brightness brightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    // Get the current brightness

    brightness = WidgetsBinding.instance.window.platformBrightness;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      brightness = WidgetsBinding.instance.window.platformBrightness;
    });

    // Log the brightness change
    print('Brightness changed to: $brightness');

    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Datenkrake',
        theme: CupertinoThemeData(
          brightness: brightness,
        ),
        home: TabbarScreen());
  }
}
