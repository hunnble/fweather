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
  String _condCode = '';
  String _condText = '';
  String _fl = '';
  String _windDir = '';
  String _windSc = '';
  List _forecast = [];

  void _getWeather(weatherType) async {
    final weather = await getWeather(_location);
    setState(() {
      final basic = weather['basic'];
      final now = weather['now'];
      _locationName = basic['location'];
      _temperature = now['tmp'];
      _condCode = now['cond_code'];
      _condText = now['cond_txt'];
      _fl = now['fl'];
      _windDir = now['wind_dir'];
      _windSc = now['wind_sc'];
    });
  }

  void _getForecast() async {
    final forecast = await getForecast(_location);
    setState(() {
      _forecast = forecast['daily_forecast'];
      print(_forecast);
    });
  }

  void _getCities(location) async {
    _cities = await getCity(location: location);
    _getWeather('now');
    _getForecast();
  }

  void _getCity(city) {
    _location = city['location'];
  }

  List<Widget> _getForecastWidgets() {
    List<Widget> widgets = _forecast.map<Widget>((_item) {
      return new Column(
        children: <Widget>[
          _getWeatherIcon(_item['cond_code_d'] ?? '999'),
          Text(
            _item['tmp_min'] + '~' + _item['tmp_max'] + '℃',
          ),
        ],
      );
    }).toList();
    return widgets;
  }

  Widget _getWeatherIcon(String condCode) {
    Color color = Colors.grey;
    final int condCodeNum = int.parse(condCode);

    if (condCodeNum == 100) {
      // clear
      color = Colors.orange;
    } else if (condCodeNum >= 206 && condCodeNum <= 213) {
      // strong gale or storm
      color = Colors.red;
    } else if (condCodeNum >= 300 && condCodeNum <= 318 || condCodeNum == 399) {
      // rain
      color = Colors.blue;
    } else if (condCodeNum >= 400 && condCodeNum <= 499) {
      // snow
      color = Colors.white;
    } else if ((condCodeNum >= 500 && condCodeNum <= 502) ||
        (condCodeNum >= 509 && condCodeNum <= 515)) {
      // fog or haze
      color = Colors.white;
    } else if (condCodeNum >= 503 && condCodeNum <= 508) {
      // dust
      color = Colors.yellow;
    }

    return new Image.network(
      'https://cdn.heweather.com/cond_icon/' + condCode + '.png',
      width: 40,
      height: 40,
      color: color,
    );
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
                _getWeatherIcon(_condCode),
                Text(_windDir + ' ' + _windSc + '级'),
              ],
            )
          ],
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            crossAxisCount: 5,
            children: _getForecastWidgets(),
          ),
        )
      ],
    );
  }
}
