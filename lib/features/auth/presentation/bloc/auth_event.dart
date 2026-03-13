import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginSubmitted({
    required String username,
    required String password,
  }) = LoginSubmitted;
}
