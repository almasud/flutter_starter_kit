import 'package:flutter/foundation.dart';
import 'package:flutter_starter_kit/features/auth/data/local/auth_session_store.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

class AuthGuard extends ChangeNotifier {
  AuthGuard(this._sessionStore);

  final AuthSessionStore _sessionStore;
  AuthSession? _session;

  bool get isAuthenticated => (_session?.token ?? '').isNotEmpty;
  AuthSession? get session => _session;

  Future<void> restore() async {
    _session = await _sessionStore.read();
    notifyListeners();
  }

  Future<void> setSession(AuthSession session) async {
    _session = session;
    await _sessionStore.save(session);
    notifyListeners();
  }

  Future<void> clearSession() async {
    _session = null;
    await _sessionStore.clear();
    notifyListeners();
  }
}
