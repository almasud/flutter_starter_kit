import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, submitting, authenticated, failure }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    AuthSession? session,
    @Default('') String message,
  }) = _AuthState;
}
