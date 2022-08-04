// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Wind {
  const Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  final double speed;
}

@JsonSerializable()
class Basic {
  const Basic({
    required this.temperature,
    required this.humidity,
  });

  factory Basic.fromJson(Map<String, dynamic> json) => _$BasicFromJson(json);

  @JsonKey(name: 'temp')
  final double temperature;
  final double humidity;
}

@JsonSerializable()
class Weather {
  const Weather({required this.wind, required this.basic});

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  final Wind wind;

  @JsonKey(name: 'main')
  final Basic basic;
}
