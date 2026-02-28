sealed class AppError {
  const AppError();
}

final class NetworkError extends AppError {
  const NetworkError({this.message});
  final String? message;
}

final class UnauthorizedError extends AppError {
  const UnauthorizedError({this.message, this.code});
  final String? message;
  final String? code;
}

final class ValidationError extends AppError {
  const ValidationError({this.message, this.code});
  final String? message;
  final String? code;
}

final class ServerError extends AppError {
  const ServerError({this.message});
  final String? message;
}

final class UnknownError extends AppError {
  const UnknownError({this.message, this.code});
  final String? message;
  final String? code;
}

