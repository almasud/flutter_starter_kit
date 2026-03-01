import 'package:dio/dio.dart';

import '../../domain/models/api_result.dart';
import '../../domain/models/app_error.dart';

/// Usage: final result = await safeApiCall(() => dio.get('/posts'));
Future<ApiResult<T, AppError>> safeApiCall<T>(
  Future<Response> Function() apiCall,
  T Function(dynamic json) fromJson,
) async {
  try {
    final response = await apiCall();
    return Success(_parseResponse<T>(response, fromJson));
  } on DioException catch (e) {
    return Failure(_mapDioError(e));
  } on FormatException catch (e) {
    return Failure(UnknownError(message: 'Parse error: ${e.message}'));
  } on TypeError catch (e) {
    return Failure(UnknownError(message: 'Type error: ${e.toString()}'));
  } catch (e) {
    return Failure(UnknownError(message: e.toString()));
  }
}

T _parseResponse<T>(Response response, T Function(dynamic json) fromJson) {
  try {
    return fromJson(response.data);
  } catch (e) {
    throw FormatException('Failed to parse dtos: $e');
  }
}

AppError _mapDioError(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.connectionError => NetworkError(message: e.message),

    DioExceptionType.badResponse => _mapStatusCode(e.response),

    _ => UnknownError(message: e.message),
  };
}

AppError _mapStatusCode(Response? response) {
  final statusCode = response?.statusCode;
  final body = response?.data;
  final message = body?['message'] as String?;
  final code = body?['code'] as String?;

  return switch (statusCode) {
    400 => ValidationError(message: message, code: code),
    401 => UnauthorizedError(message: message, code: code),
    403 => UnauthorizedError(message: message, code: code),
    408 => NetworkError(message: 'Request timeout'),
    500 ||
    502 ||
    503 => ServerError(message: message ?? 'Internal server error'),
    _ => UnknownError(message: message, code: code?.toString()),
  };
}
