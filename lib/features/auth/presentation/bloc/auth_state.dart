import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

enum AuthStatus { initial, submitting, authenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.message = '',
  });

  final AuthStatus status;
  final AuthSession? session;
  final String message;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      message: message ?? this.message,
    );
  }
}
