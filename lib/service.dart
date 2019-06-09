import 'dart:convert' show utf8, json;
import 'dart:io';
import 'configs.dart' show searchHost, weatherHost, weatherApiKey;

const defaultParams = {};

request(String scheme, String host,
    {String path, Object params = defaultParams}) async {
  final httpClient = new HttpClient();
  final uri =
      Uri(scheme: scheme, host: host, path: path, queryParameters: params);
  final request = await httpClient.getUrl(uri);
  final response = await request.close();
  final jsonData = await response.transform(utf8.decoder).join();
  final data = json.decode(jsonData);
  return {
    'statusCode': response.statusCode,
    'data': data,
  };
}

getData(res) {
  return res['data']['HeWeather6'][0];
}

getCity({String location, String mode = 'match', String number = '20'}) async {
  final res = await request('https', searchHost, path: '/find', params: {
    'location': location,
    'key': weatherApiKey,
    'mode': mode,
    'number': number,
  });
  return getData(res)['basic'];
}

getWeather(_location) async {
  final res = await request('https', weatherHost,
      path: '/s6/weather/now',
      params: {'location': _location, 'key': weatherApiKey});
  return getData(res);
}

getForecast(_location) async {
  final res = await request('https', weatherHost,
      path: '/s6/weather/forecast',
      params: {'location': _location, 'key': weatherApiKey});
  return getData(res);
}
