import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/utils/config.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_response.dart';

enum HttpMethod { get, post, patch, put, delete }

class ApiService {
  final log = getLogger('ApiService');

  static final Map<String, String> _requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static const int _timeout = 50000;

  static final _options = BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: _requestHeaders,
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
  );

  Dio _dio() {
    Dio dio;
    if (!kReleaseMode) {
      dio = Dio(_options)
        ..interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ));
    } else {
      dio = Dio(_options);
    }
    return dio;
  }

  Future<ApiResponse> call({
    required HttpMethod method,
    required String endpoint,
    Map<String, dynamic>? reqBody,
    Map<String, dynamic>? reqParams,
    FormData? formData,
    bool protected = true,
    bool useFormData = false,
  }) async {
    try {
      switch (method) {
        case HttpMethod.post:
          Response response = await _dio().post(
            endpoint,
            queryParameters: reqParams,
            data: useFormData ? formData : reqBody,
            options: Options(
                headers: !protected
                    ? {}
                    : {"Authorization": "Bearer ${await _getToken()}"}),
          );
          return ApiResponse(response);

        case HttpMethod.get:
          Response response = await _dio().get(
            queryParameters: reqParams,
            endpoint,
            options: Options(
                headers: !protected
                    ? {}
                    : {"Authorization": "Bearer ${await _getToken()}"}),
          );
          return ApiResponse(response);
        case HttpMethod.patch:
          Response response = await _dio().patch(
            endpoint,
            data: useFormData ? formData : reqBody,
            options: Options(
                headers: !protected
                    ? {}
                    : {"Authorization": "Bearer ${await _getToken()}"}),
          );
          return ApiResponse(response);
        case HttpMethod.put:
          Response response = await _dio().put(
            endpoint,
            data: useFormData ? formData : reqBody,
            options: Options(
                headers: !protected
                    ? {}
                    : {"Authorization": "Bearer ${await _getToken()}"}),
          );
          return ApiResponse(response);
        case HttpMethod.delete:
          Response response = await _dio().delete(
            endpoint,
            data: useFormData ? formData : reqBody,
            options: Options(
                headers: !protected
                    ? {}
                    : {"Authorization": "Bearer ${await _getToken()}"}),
          );
          return ApiResponse(response);
      }
    } on DioError catch (e) {
      log.e(e.message);
      if (e.type == DioErrorType.connectTimeout) {
        return ApiResponse(
          Response(
            statusCode: 504,
            data: "Request timeout",
            requestOptions: RequestOptions(path: ''),
          ),
        );
      } else if (e.type == DioErrorType.other) {
        return ApiResponse(
          Response(
            statusCode: 101,
            data: "Network is unreachable",
            requestOptions: RequestOptions(path: ''),
          ),
        );
      } else if (e.type == DioErrorType.receiveTimeout) {
        return ApiResponse(
          Response(
            statusCode: 504,
            data: "Receive timeout",
            requestOptions: RequestOptions(path: ''),
          ),
        );
      }
      return ApiResponse(e.response!);
    }
  }

  Future<String> _getToken() async {
    final localStorage = locator<LocalStorage>();
    String? token = await localStorage.fetch(LocalStorageDir.authToken);
    return token ?? "";
  }
}
