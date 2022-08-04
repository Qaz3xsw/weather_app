import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class CityCoordinates {
  CityCoordinates({
    required this.lat,
    required this.lon,
    required this.name,
  });

  final double lat;
  final double lon;
  final String name;

  factory CityCoordinates.fromJson(Map<String, dynamic> json) => _$CityCoordinatesFromJson(json);
}
