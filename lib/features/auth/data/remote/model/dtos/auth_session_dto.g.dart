// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    _AuthSessionDto(
      userId: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );

Map<String, dynamic> _$AuthSessionDtoToJson(_AuthSessionDto instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'username': instance.username,
      'accessToken': instance.accessToken,
      'token': instance.token,
    };
