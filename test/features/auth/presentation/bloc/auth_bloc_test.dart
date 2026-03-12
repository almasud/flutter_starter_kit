import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/core/presentation/router/auth_guard.dart';
import 'package:flutter_starter_kit/features/auth/data/local/auth_session_store.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';
import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryAuthSessionStore extends AuthSessionStore {
  AuthSession? _session;

  @override
  Future<void> clear() async {
    _session = null;
  }

  @override
  Future<AuthSession?> read() async => _session;

  @override
  Future<void> save(AuthSession session) async {
    _session = session;
  }
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(this._handler);

  final Future<ApiResult<AuthSession, AppError>> Function({
    required String username,
    required String password,
  })
  _handler;

  @override
  Future<ApiResult<AuthSession, AppError>> login({
    required String username,
    required String password,
  }) {
    return _handler(username: username, password: password);
  }

  @override
  Future<AuthSession?> getSavedSession() async => null;

  @override
  Future<void> clearSavedSession() async {}
}

void main() {
  group('AuthBloc', () {
    test('emits failure for empty credentials', () async {
      final repository = _FakeAuthRepository(
        ({required username, required password}) async =>
            const Failure(UnauthorizedError(message: 'invalid')),
      );
      final store = _InMemoryAuthSessionStore();
      final guard = AuthGuard(store);
      final bloc = AuthBloc(LoginUseCase(repository), guard);

      bloc.add(const LoginSubmitted(username: ' ', password: ' '));

      await expectLater(
        bloc.stream,
        emits(
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.failure)
              .having(
                (s) => s.message,
                'message',
                'Username and password are required',
              ),
        ),
      );
    });

    test('emits submitting then authenticated and persists session', () async {
      const session = AuthSession(userId: 10, username: 'alice', token: 'tkn');
      final repository = _FakeAuthRepository(
        ({required username, required password}) async =>
            const Success(session),
      );
      final store = _InMemoryAuthSessionStore();
      final guard = AuthGuard(store);
      final bloc = AuthBloc(LoginUseCase(repository), guard);

      bloc.add(const LoginSubmitted(username: 'alice', password: 'secret123'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having(
            (s) => s.status,
            'status',
            AuthStatus.submitting,
          ),
          isA<AuthState>().having(
            (s) => s.status,
            'status',
            AuthStatus.authenticated,
          ),
        ]),
      );

      expect(guard.isAuthenticated, isTrue);
      expect((await store.read())?.token, 'tkn');
    });
  });
}
