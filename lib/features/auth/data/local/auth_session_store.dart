import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

abstract class AuthSessionStore {
  Future<void> save(AuthSession session);
  Future<AuthSession?> read();
  Future<void> clear();
}

class SecureAuthSessionStore extends AuthSessionStore {
  SecureAuthSessionStore(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _kToken = 'auth_token';
  static const _kUsername = 'auth_username';
  static const _kUserId = 'auth_user_id';

  @override
  Future<void> save(AuthSession session) async {
    await _secureStorage.write(key: _kToken, value: session.token);
    await _secureStorage.write(key: _kUsername, value: session.username);
    await _secureStorage.write(key: _kUserId, value: session.userId.toString());
  }

  @override
  Future<AuthSession?> read() async {
    final token = await _secureStorage.read(key: _kToken);
    final username = await _secureStorage.read(key: _kUsername);
    final userIdRaw = await _secureStorage.read(key: _kUserId);
    final userId = int.tryParse(userIdRaw ?? '');

    if (token == null || token.isEmpty || username == null || userId == null) {
      return null;
    }

    return AuthSession(userId: userId, username: username, token: token);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.delete(key: _kToken);
    await _secureStorage.delete(key: _kUsername);
    await _secureStorage.delete(key: _kUserId);
  }
}
