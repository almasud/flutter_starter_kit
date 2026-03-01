import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/data/remote/safe_api_call.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/data/remote/model/dtos/auth_session_dto.dart';

abstract class AuthDatasource {
  Future<ApiResult<AuthSessionDto, AppError>> login({
    required String username,
    required String password,
  });
}

class AuthDatasourceImpl extends AuthDatasource {
  AuthDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ApiResult<AuthSessionDto, AppError>> login({
    required String username,
    required String password,
  }) => safeApiCall(
    () => _dio.post(
      '/auth/login',
      data: <String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    ),
    (json) => AuthSessionDto.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}
