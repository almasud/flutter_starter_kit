class AuthSessionDto {
  const AuthSessionDto({
    required this.userId,
    required this.username,
    required this.token,
  });

  final int userId;
  final String username;
  final String token;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionDto(
      userId: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      token: (json['accessToken'] ?? json['token'] ?? '') as String,
    );
  }
}
