import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

abstract class SessionStorage {
  Future<void> save(AuthSession session);

  Future<AuthSession?> read();

  Future<void> clear();
}

class SessionStorageImpl extends SessionStorage {
  SessionStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _userIdKey = 'auth.user_id';
  static const _usernameKey = 'auth.username';
  static const _tokenKey = 'auth.token';

  @override
  Future<void> save(AuthSession session) async {
    await _storage.write(key: _userIdKey, value: session.userId.toString());
    await _storage.write(key: _usernameKey, value: session.username);
    await _storage.write(key: _tokenKey, value: session.token);
  }

  @override
  Future<AuthSession?> read() async {
    final userIdValue = await _storage.read(key: _userIdKey);
    final username = await _storage.read(key: _usernameKey);
    final token = await _storage.read(key: _tokenKey);

    if (userIdValue == null || username == null || token == null) {
      return null;
    }

    final userId = int.tryParse(userIdValue);
    if (userId == null) {
      await clear();
      return null;
    }

    return AuthSession(userId: userId, username: username, token: token);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _tokenKey);
  }
}
