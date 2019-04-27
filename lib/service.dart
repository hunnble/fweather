import 'dart:convert' show utf8, json;
import 'dart:io';

const defaultParams = {};

request(String scheme, String host, { String path, Object params = defaultParams }) async {
  var httpClient = new HttpClient();
  var uri = Uri(scheme: scheme, host: host, path: path, queryParameters: params);
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var jsonData = await response.transform(utf8.decoder).join();
  var data = json.decode(jsonData);
  return {
    'statusCode': response.statusCode,
    'data': data,
  };
}
