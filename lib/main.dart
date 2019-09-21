import 'package:flutter/material.dart';
import 'package:fweather/service.dart';
import 'service.dart' show getCity, getWeather, getForecast;
import 'theme_data.dart' show themeData;

const double IconSize = 40.0;
// const List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日', '周一'];
const List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'Monday'];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: themeData,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Weather();
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
  String _location = 'Beijing';
  String _locationName = '';
  String _temperature = '';
  String _condCode = '';
  String _windSpd = '';
  String _hum = '';
  String _pcpn = '';
  List _forecast = [];

  void _getWeather(weatherType) async {
    final weather = await getWeather(_location);
    setState(() {
      final basic = weather['basic'] ?? {};
      final now = weather['now'] ?? {};
      _locationName = basic['location'] ?? '';
      _temperature = now['tmp'] ?? '';
      _condCode = now['cond_code'] ?? '';
      _windSpd = now['wind_spd'] ?? '';
      _hum = now['hum'] ?? '';
      _pcpn = now['pcpn'] ?? '';
    });
  }

  void _getForecast() async {
    final forecast = await getForecast(_location);
    setState(() {
      _forecast = forecast['daily_forecast'] ?? [];
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

  Widget _getWeatherIcon(String condCode, {double size = IconSize}) {
    return new Image.network(
      'https://cdn.heweather.com/cond_icon/' + condCode + '.png',
      width: size,
      height: size,
      color: themeData.textTheme.display1.color,
    );
  }

  Widget _getLocationInputWidget() {
    return new TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        labelText: 'Location',
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _getCities('beijing');
  }

  @override
  Widget build(BuildContext context) {
    if (_temperature.length == 0) {
      return Text('');
    }
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // _getLocationInputWidget(),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Text(
                      weekdays[new DateTime.now().weekday],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontFamily: themeData.textTheme.display1.fontFamily,
                        color: themeData.textTheme.display1.color,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        _locationName,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: themeData.textTheme.display1.fontFamily,
                          color: themeData.textTheme.display1.color,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: _getWeatherIcon(_condCode, size: 60.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' ' + _temperature,
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w600,
                              fontFamily: themeData.textTheme.display1.fontFamily,
                              color: themeData.textTheme.display1.color,
                            ),
                          ),
                          Text(
                            '° ',
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w200,
                              color: themeData.textTheme.display1.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: <Widget>[
                        Text(
                          weekdays[new DateTime.now()
                              .add(new Duration(days: 1))
                              .weekday],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            fontFamily: themeData.textTheme.display1.fontFamily,
                            color: themeData.textTheme.display1.color,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getWeatherIcon(
                                _forecast[0]['cond_code_d'] ?? '999'),
                            Text(
                              _forecast[0]['tmp_min'] +
                                  '°/' +
                                  _forecast[0]['tmp_max'] +
                                  '°',
                              style: TextStyle(
                                fontFamily: themeData.textTheme.display1.fontFamily,
                                color: themeData.textTheme.display1.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              _getWeatherIcon('507'),
                              Text(
                                _windSpd + 'km/h',
                                style: TextStyle(
                                  fontFamily: themeData.textTheme.display1.fontFamily,
                                  color: themeData.textTheme.display1.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              _getWeatherIcon('399'),
                              Text(
                                _pcpn + 'mm',
                                style: TextStyle(
                                  fontFamily: themeData.textTheme.display1.fontFamily,
                                  color: themeData.textTheme.display1.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.bubble_chart,
                                size: IconSize,
                                color: themeData.textTheme.display1.color,
                              ),
                              Text(
                                _hum + '%',
                                style: TextStyle(
                                  fontFamily: themeData.textTheme.display1.fontFamily,
                                  color: themeData.textTheme.display1.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
