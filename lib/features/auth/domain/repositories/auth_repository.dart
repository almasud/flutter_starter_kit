import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthSession, AppError>> login({
    required String username,
    required String password,
  });
}
