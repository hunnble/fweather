import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Maid',
      home: HomeScreen(),
    );
  }
}

const devicesTabName = '设备';
const statisticTabName = '统计';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear_solid),
              title: Text(devicesTabName)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.folder_solid),
              title: Text(statisticTabName)),
        ]),
        tabBuilder: (context, position) {
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: position == 0
                      ? Text(devicesTabName)
                      : Text(statisticTabName),
                ),
                child: position == 0
                    ? new Devices(position.toString())
                    : Text(statisticTabName),
              );
            },
          );
        });
  }
}

/// devices page
class Devices extends StatelessWidget {
  final String position;
  Devices(this.position);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("欢迎来到 :$position"),
    );
  }
}
