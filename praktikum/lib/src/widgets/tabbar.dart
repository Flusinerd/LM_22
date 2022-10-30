import 'package:flutter/cupertino.dart';
import 'package:praktikum/src/screens/home.dart';

import '../screens/data.dart';
import '../screens/settings.dart';

// CuppertinoTabbarWidget
class TabbarScreen extends StatelessWidget {
  const TabbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(''),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.folder),
              label: 'Data',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return const HomeScreen();
            case 1:
              return const SettingsScreen();
            case 2:
              return DataScreen();
            default:
              return const HomeScreen();
          }
        },
      ),
    );
  }
}
