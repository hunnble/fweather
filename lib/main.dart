import 'package:flutter/material.dart';
import 'configs.dart' show weatherApiKey;
import 'service.dart' show request;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maid',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DevicesPage(),
      ),
    );
  }
}

/// devices page
class DevicesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DevicePageState();
  }
}

class _DevicePageState extends State<DevicesPage> {
  _getWeather(weatherType) async {
    var data = await request('https', 'free-api.heweather.net', path: '/s6/weather/now', params: {
      'location': 'beijing',
      'key': weatherApiKey
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("devices"),
        RaisedButton(
          onPressed: () => {
            _getWeather('now')
          },
          child: new Text('Get Weather'),
        ),
      ]
    );
  }
}
