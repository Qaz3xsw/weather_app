/// As bloc acts like application layer here, application layer
/// usually handle user specific errors. Errors belong to this layer in this
/// concrete simple study app. So repository depends on bloc.

enum CodeType { http, json }

class ResponseCodeException implements Exception {
  const ResponseCodeException(
    this.message, {
    required this.code,
    required this.url,
    required this.codeType,
    // other useful data to figure out why error occurs
  });

  final String message;
  final int code;
  final String url;
  final CodeType codeType;
}

class CityNotExistsException implements Exception {
  const CityNotExistsException({required this.cityName});
  final String cityName;
}
