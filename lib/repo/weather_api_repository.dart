import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/bloc/errors.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/model/city.dart';
import 'package:weather_app/model/weather.dart';

class WeatherRepository implements IWeatherRepository {
  // this should come from outside..
  final String domain = 'api.openweathermap.org';
  final String apiKey;

  WeatherRepository({required this.apiKey});

  /// Get city geo by name
  Future<CityCoordinates> getCityCoordinatesByName(String cityName) async {
    const String requestPath = '/geo/1.0/direct';

    // prepare request options
    Map<String, dynamic> params = {
      'q': cityName,
      'limit': 1.toString(),
      'appid': apiKey,
    };

    // this endpoint do not return [cod]..
    final List<dynamic> decoded = await _makeRequest(requestPath, params);
    if (decoded.isEmpty) {
      throw CityNotExistsException(cityName: cityName);
    }

    final CityCoordinates cityCoordinates = CityCoordinates.fromJson(decoded.first);
    return cityCoordinates;
  }

  /// Get weather by city
  @override
  Future<Weather> requestWeatherByCity(String cityName) async {
    final CityCoordinates city = await getCityCoordinatesByName(cityName);
    const String requestPath = 'data/2.5/weather';

    Map<String, dynamic> params = {
      'lat': city.lat.toString(),
      'lon': city.lon.toString(),
      'appid': apiKey,
    };

    final Map<String, dynamic> decoded = await _makeRequest(requestPath, params);

    // backend specific error handling for this concrete endpoint
    // it returns [cod], which shows request is successful or not
    final jsonCode = decoded['cod'];
    if (jsonCode != 200) {
      throw ResponseCodeException(
        'bad json response status code',
        code: jsonCode,
        codeType: CodeType.json,
        url: '$domain$requestPath', // this should be useful url string
      );
    }

    final Weather weather = Weather.fromJson(decoded);
    return weather;
  }

  /// _makeRequest makes http requests, handles http errors only, as low level function)
  Future<dynamic> _makeRequest(String path, Map<String, dynamic> params) async {
    final requestUri = Uri.http(domain, path, params);
    final http.Response response = await http.get(requestUri);

    // handle http specific response errors
    if (response.statusCode != 200) {
      throw ResponseCodeException(
        'bas status code',
        code: response.statusCode,
        codeType: CodeType.http,
        url: requestUri.toString(), // should be parsed..
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    return decoded;
  }
}
