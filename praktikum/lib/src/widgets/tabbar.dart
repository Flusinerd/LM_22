import 'package:flutter/cupertino.dart';
import 'package:praktikum/src/screens/home.dart';

//import '../screens/data.dart';
import '../screens/settings.dart';
import '../screens/charts.dart';
import '../screens/list.dart';
import '../screens/map.dart';

// CuppertinoTabbarWidget

final GlobalKey<ListScreenState> listKey = GlobalKey();
final GlobalKey<ChartsScreenState> chartKey = GlobalKey();

class TabbarScreen extends StatelessWidget {
  /*ListScreen listScreen = ListScreen(key: listKey);
  ChartsScreen chartsScreen = ChartsScreen(key: chartKey);*/
  const TabbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
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
          /*BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder),
            label: 'Data',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_square),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_dash),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: 'Map',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return SettingsScreen(onDataSend: (String out) {
              listKey.currentState!.updateData(out);
              chartKey.currentState!.updateData(out);
            });
          /*case 2:
            return DataScreen();*/
          case 2:
            return ChartsScreen(key: chartKey);
          //return chartsScreen;
          case 3:
            return ListScreen(key: listKey);
          //return listScreen;
          case 4:
            return MapScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
