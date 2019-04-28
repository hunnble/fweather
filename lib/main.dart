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
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: 300,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Weather(),
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
  String _condText = '';
  String _fl = '';
  String _windDir = '';
  String _windSc = '';

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
      _condText = now['cond_txt'];
      _fl = now['fl'];
      _windDir = now['wind_dir'];
      _windSc = now['wind_sc'];
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_locationName),
        Row(
          children: <Widget>[
            Text(
              _temperature + '℃',
              style: TextStyle(
                fontSize: 70,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_condText),
                Text('体感温度:' + _fl + '℃'),
                Text(_windDir + ' ' + _windSc + '级'),
              ],
            )
          ],
        )
      ],
    );
  }
}
