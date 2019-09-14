import 'package:flutter/material.dart';
import 'package:maid/service.dart';
import 'service.dart' show getCity, getWeather, getForecast;
import 'theme_data.dart' show themeData;

const double IconSize = 40.0;
const List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日', '周一'];

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
  String _location = '北京';
  String _locationName = '';
  String _temperature = '';
  String _condCode = '';
  String _condText = '';
  String _fl = '';
  String _windDir = '';
  String _windSpd = '';
  String _hum = '';
  String _pcpn = '';
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
      _windSpd = now['wind_spd'];
      _hum = now['hum'];
      _pcpn = now['pcpn'];
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

  Widget _getWeatherIcon(String condCode, {double size = IconSize}) {
    Color color = Colors.grey;
    final int condCodeNum = int.parse(condCode);

    // TODO: refactor
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
      width: size,
      height: size,
      color: Colors.white,
      // color: color,
    );
  }

  Widget _getLocationInputWidget() {
    return new TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        labelText: '地区',
      ),
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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // _getLocationInputWidget(),
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    _locationName,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 8,
                    ),
                  ),
                  Text(
                    weekdays[new DateTime.now().weekday],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: _getWeatherIcon(_condCode, size: 50.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      ' ' + _temperature + '°',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            Center(
              // child: Text(_windDir + ' ' + _windSpd + '级'),
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
                              Text(_windSpd + 'km/h'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              _getWeatherIcon('399'),
                              Text(_pcpn + 'mm'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.bubble_chart,
                                size: IconSize,
                              ),
                              Text(_hum + '%'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: GridView.count(
            //     primary: false,
            //     crossAxisCount: 5,
            //     children: _getForecastWidgets(),
            //   ),
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   // color: themeData.accentColor,
      //   child: Container(
      //     height: 90.0,
      //   ),
      // ),
    );
  }
}
