// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class CityCoordinates {
  const CityCoordinates({
    required this.lat,
    required this.lon,
    required this.name,
  });

  factory CityCoordinates.fromJson(Map<String, dynamic> json) => _$CityCoordinatesFromJson(json);

  final double lat;
  final double lon;
  final String name;
}
