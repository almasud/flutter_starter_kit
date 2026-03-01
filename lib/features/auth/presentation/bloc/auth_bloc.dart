import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._loginUseCase) : super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final username = event.username.trim();
    final password = event.password.trim();

    if (username.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Username and password are required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, message: ''));

    final result = await _loginUseCase(username: username, password: password);

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            session: data,
            message: '',
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(status: AuthStatus.failure, message: _mapError(error)),
        );
    }
  }

  String _mapError(AppError error) {
    return switch (error) {
      NetworkError(:final message) => message ?? 'Network error',
      UnauthorizedError(:final message) => message ?? 'Unauthorized',
      ValidationError(:final message) => message ?? 'Validation error',
      ServerError(:final message) => message ?? 'Server error',
      UnknownError(:final message) => message ?? 'Unknown error',
    };
  }
}
