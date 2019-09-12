import 'package:flutter/material.dart';
import 'package:maid/service.dart';
import 'service.dart' show getCity, getWeather, getForecast;
import 'theme_data.dart' show themeData;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maid',
      theme: themeData,
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
        child: Weather(),
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
  List _cities = [];
  String _location = '北京';
  String _locationName = '';
  String _temperature = '';
  String _condText = '';
  String _fl = '';
  String _windDir = '';
  String _windSc = '';
  List _forecast = [];

  _getWeather(weatherType) async {
    final weather = await getWeather(_location);
    setState(() {
      final basic = weather['basic'];
      final now = weather['now'];
      _locationName = basic['location'];
      _temperature = now['tmp'];
      _condText = now['cond_txt'];
      _fl = now['fl'];
      _windDir = now['wind_dir'];
      _windSc = now['wind_sc'];
    });
  }

  _getForecast() async {
    final forecast = await getForecast(_location);
    setState(() {
      _forecast = forecast['daily_forecast'];
      print(_forecast);
    });
  }

  _getCities(location) async {
    _cities = await getCity(location: location);
    _getWeather('now');
    _getForecast();
  }

  _getCity(city) {
    _location = city['location'];
  }

  @override
  initState() {
    _getCities('beijing');
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
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _forecast.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                  title: new Text(_forecast[index]['cond_txt_d']));
            },
          ),
        )
      ],
    );
  }
}
