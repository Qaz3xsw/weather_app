/// As bloc acts like application layer here, application layer
/// usually handle user specific errors. Errors belong to this layer in this
/// concrete simple study app. So repository depends on bloc.

enum CodeType { http, json }

class ResponseCodeException implements Exception {
  ResponseCodeException(
    this.message, {
    required this.code,
    required this.url,
    required this.codeType,
    // other useful data to figure out an error
  });

  final String message;
  final int code;
  final String url;
  final CodeType codeType;
}

class CityNotExistsException implements Exception {
  CityNotExistsException({required this.cityName});
  final String cityName;
}
