import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../config/app_env.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([_RequestTracingInterceptor()]);

    return dio;
  }
}

class _RequestTracingInterceptor extends Interceptor {
  static const _requestIdKey = 'request_id';
  static const _requestStartMsKey = 'request_started_at_ms';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestId = _generateRequestId();
    final startedAt = DateTime.now().millisecondsSinceEpoch;
    options.headers['X-Request-Id'] = requestId;
    options.extra[_requestIdKey] = requestId;
    options.extra[_requestStartMsKey] = startedAt;

    if (kDebugMode) {
      debugPrint('[REQ][$requestId] ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final requestId = err.requestOptions.extra[_requestIdKey] as String?;
      final durationMs = _durationMs(err.requestOptions.extra);
      debugPrint(
        '[ERR][${requestId ?? '-'}][${durationMs}ms] ${err.requestOptions.method} '
        '${err.requestOptions.uri} :: ${err.type.name}',
      );
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final requestId = response.requestOptions.extra[_requestIdKey] as String?;
      final durationMs = _durationMs(response.requestOptions.extra);
      debugPrint(
        '[RES][${requestId ?? '-'}][${durationMs}ms] ${response.statusCode} '
        '${response.requestOptions.method} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  int _durationMs(Map<String, dynamic> extra) {
    final start = extra[_requestStartMsKey] as int?;
    if (start == null) return 0;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  String _generateRequestId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final randomPart = Random().nextInt(999999).toString().padLeft(6, '0');
    return '$now-$randomPart';
  }
}
