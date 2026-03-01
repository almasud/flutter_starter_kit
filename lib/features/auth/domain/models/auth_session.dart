class AuthSession {
  const AuthSession({
    required this.userId,
    required this.username,
    required this.token,
  });

  final int userId;
  final String username;
  final String token;
}
