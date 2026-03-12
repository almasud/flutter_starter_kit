import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';
import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';

class GetSavedSessionUseCase {
  const GetSavedSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession?> call() {
    return _repository.getSavedSession();
  }
}
