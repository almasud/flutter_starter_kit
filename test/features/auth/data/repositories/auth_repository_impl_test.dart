import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/remote/model/dtos/auth_session_dto.dart';
import 'package:flutter_starter_kit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

class _FakeAuthDatasource extends AuthDatasource {
  _FakeAuthDatasource(this._result);

  final ApiResult<AuthSessionDto, AppError> _result;

  @override
  Future<ApiResult<AuthSessionDto, AppError>> login({
    required String username,
    required String password,
  }) async {
    return _result;
  }
}

void main() {
  group('AuthRepositoryImpl.login', () {
    test('returns mapped AuthSession on success', () async {
      final datasource = _FakeAuthDatasource(
        const Success(
          AuthSessionDto(userId: 1, username: 'demo', token: 'dummy-token'),
        ),
      );
      final repository = AuthRepositoryImpl(datasource);

      final result = await repository.login(
        username: 'demo',
        password: 'demo123',
      );

      expect(result, isA<Success<AuthSession, AppError>>());
      final success = result as Success<AuthSession, AppError>;
      expect(success.data.userId, 1);
      expect(success.data.username, 'demo');
      expect(success.data.token, 'dummy-token');
    });

    test('forwards AppError on failure', () async {
      const appError = UnauthorizedError(message: 'Invalid credentials');
      final datasource = _FakeAuthDatasource(const Failure(appError));
      final repository = AuthRepositoryImpl(datasource);

      final result = await repository.login(
        username: 'wrong',
        password: 'wrong',
      );

      expect(result, isA<Failure<AuthSession, AppError>>());
      final failure = result as Failure<AuthSession, AppError>;
      expect(failure.error, appError);
    });
  });
}
