import 'package:flutter_starter_kit/features/auth/data/remote/model/dtos/auth_session_dto.dart';
import 'package:flutter_starter_kit/features/auth/domain/models/auth_session.dart';

extension AuthSessionDtoMapper on AuthSessionDto {
  AuthSession toDomain() {
    return AuthSession(
      userId: userId,
      username: username,
      token: accessToken.isNotEmpty ? accessToken : token,
    );
  }
}
