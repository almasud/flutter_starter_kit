import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    @JsonKey(name: 'id') @Default(0) int userId,
    @Default('') String username,
    @JsonKey(name: 'accessToken') @Default('') String accessToken,
    @Default('') String token,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);
}
