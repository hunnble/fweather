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
        child: Container(
          child: Card(
            child: Row(
              children: <Widget>[
                Weather(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WeatherState();
  }
}

class _WeatherState extends State<Weather> {
  String _location = 'beijing';
  String _locationName = '';
  String _temperature = '';

  _getWeather(weatherType) async {
    var response = await request('https', 'free-api.heweather.net',
        path: '/s6/weather/now',
        params: {'location': _location, 'key': weatherApiKey});
    print(response['data']['HeWeather6'][0]);
    setState(() {
      var weather = response['data']['HeWeather6'][0];
      var basic = weather['basic'];
      var now = weather['now'];
      _locationName = basic['location'];
      _temperature = now['tmp'];
    });
  }

  @override
  initState() {
    _getWeather('now');
  }

  @override
  Widget build(BuildContext context) {
    if (_temperature.length == 0) {
      return Text('');
    }
    return Column(
      children: <Widget>[
        Text(_locationName),
        Row(
          children: <Widget>[
            Text(_temperature + '℃'),
          ],
        )
      ],
    );
  }
}
