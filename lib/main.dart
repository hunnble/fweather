import 'package:flutter/material.dart';
import 'package:maid/service.dart';
import 'service.dart' show getWeather, getForecast;

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
    var weather = await getWeather(_location);
    setState(() {
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

  _getForecast() async {
    var forecast = await getForecast(_location);
    print(forecast);
  }

  @override
  initState() {
    _getWeather('now');
    _getForecast();
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
