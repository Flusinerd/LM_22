import 'package:flutter/cupertino.dart';
import 'package:praktikum/src/widgets/tabbar.dart';

class DatenkrakeApp extends StatelessWidget {
  const DatenkrakeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        title: 'Datenkrake',
        theme: CupertinoThemeData(brightness: Brightness.dark),
        home: TabbarScreen());
  }
}
