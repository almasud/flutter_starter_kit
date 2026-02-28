import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _LoginInterceptor(),
    ]);

    return dio;
  }
}

class _LoginInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('Request: ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Error: ${err.message}');
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }
}

