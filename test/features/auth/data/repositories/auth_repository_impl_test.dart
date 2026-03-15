import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/local/auth_session_store.dart';
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

class _FakeAuthSessionStore extends AuthSessionStore {
  AuthSession? session;

  @override
  Future<void> clear() async {
    session = null;
  }

  @override
  Future<AuthSession?> read() async {
    return session;
  }

  @override
  Future<void> save(AuthSession session) async {
    this.session = session;
  }
}

void main() {
  group('AuthRepositoryImpl', () {
    test('returns mapped AuthSession on success and stores session', () async {
      final sessionStorage = _FakeAuthSessionStore();
      final datasource = _FakeAuthDatasource(
        const Success(
          AuthSessionDto(userId: 1, username: 'demo', token: 'dummy-token'),
        ),
      );
      final repository = AuthRepositoryImpl(datasource, sessionStorage);

      final result = await repository.login(
        username: 'demo',
        password: 'demo123',
      );

      expect(result, isA<Success<AuthSession, AppError>>());
      final success = result as Success<AuthSession, AppError>;
      expect(success.data.userId, 1);
      expect(success.data.username, 'demo');
      expect(success.data.token, 'dummy-token');
      expect(sessionStorage.session?.token, 'dummy-token');
    });

    test('forwards AppError on failure', () async {
      const appError = UnauthorizedError(message: 'Invalid credentials');
      final sessionStorage = _FakeAuthSessionStore();
      final datasource = _FakeAuthDatasource(const Failure(appError));
      final repository = AuthRepositoryImpl(datasource, sessionStorage);

      final result = await repository.login(
        username: 'wrong',
        password: 'wrong',
      );

      expect(result, isA<Failure<AuthSession, AppError>>());
      final failure = result as Failure<AuthSession, AppError>;
      expect(failure.error, appError);
      expect(sessionStorage.session, isNull);
    });

    test('returns saved session when present', () async {
      final sessionStorage = _FakeAuthSessionStore()
        ..session = const AuthSession(
          userId: 7,
          username: 'saved',
          token: 'token-7',
        );
      final repository = AuthRepositoryImpl(
        _FakeAuthDatasource(
          const Failure(UnauthorizedError(message: 'unused')),
        ),
        sessionStorage,
      );

      final session = await repository.getSavedSession();

      expect(session?.username, 'saved');
      expect(session?.token, 'token-7');
    });
  });
}
