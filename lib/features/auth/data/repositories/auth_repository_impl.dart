import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/local/auth_session_store.dart';
import 'package:flutter_starter_kit/features/auth/data/mappers/auth_mapper.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';
import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(this._datasource, this._sessionStore);

  final AuthDatasource _datasource;
  final AuthSessionStore _sessionStore;

  @override
  Future<ApiResult<AuthSession, AppError>> login({
    required String username,
    required String password,
  }) async {
    final result = await _datasource.login(
      username: username,
      password: password,
    );
    switch (result) {
      case Success(:final data):
        final session = data.toDomain();
        await _sessionStore.save(session);
        return Success(session);
      case Failure(:final error):
        return Failure(error);
    }
  }

  @override
  Future<AuthSession?> getSavedSession() {
    return _sessionStore.read();
  }

  @override
  Future<void> clearSavedSession() {
    return _sessionStore.clear();
  }
}
