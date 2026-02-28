import 'package:flutter_starter_kit/core/domain/models/app_error.dart';

sealed class ApiResult<D, E extends AppError> {
  const ApiResult();
}

final class Success<D, E extends AppError> extends ApiResult<D, E> {
  const Success(this.data);
  final D data;
}

final class Failure<D, E extends AppError> extends ApiResult<D, E> {
  const Failure(this.error);
  final E error;
}

extension ApiResultX<D, E extends AppError> on ApiResult<D, E> {
  ApiResult<R, E> map<R>(R Function(D data) transform) => switch (this) {
    Success(:final data) => Success(transform(data)),
    Failure(:final error) => Failure(error),
  };

  ApiResult<D, E> onSuccess(void Function(D data) action) {
    if (this case Success(:final data)) action(data);
    return this;
  }

  ApiResult<D, E> onError(void Function(E error) action) {
    if (this case Failure(:final error)) action(error);
    return this;
  }
}
