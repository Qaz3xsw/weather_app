import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Wind {
  Wind({required this.speed});
  final double speed;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@JsonSerializable()
class Basic {
  Basic({
    required this.temperature,
    required this.humidity,
  });

  @JsonKey(name: 'temp')
  final double temperature;
  final double humidity;

  factory Basic.fromJson(Map<String, dynamic> json) => _$BasicFromJson(json);
}

@JsonSerializable()
class Weather {
  Weather({required this.wind, required this.basic});

  final Wind wind;

  @JsonKey(name: 'main')
  final Basic basic;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
