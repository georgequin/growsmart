import 'package:dio/dio.dart';

class ApiResponse {
  Response response;

  ApiResponse(this.response);

  dynamic _data;
  int? _statusCode;

  dynamic get data {
    _data = response.data;
    return _data;
  }

  int? get statusCode {
    _statusCode = response.statusCode;
    return _statusCode;
  }
}
