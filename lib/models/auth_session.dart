import 'user_profile.dart';

class AuthSession {
  final UserProfile user;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;

  AuthSession({
    required this.user,
    this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : json;
    final sessionData = json['session'] is Map<String, dynamic> ? json['session'] as Map<String, dynamic> : null;

    return AuthSession(
      user: UserProfile.fromJson(userData),
      accessToken: sessionData?['access_token']?.toString() ?? json['token']?.toString() ?? json['accessToken']?.toString(),
      refreshToken: sessionData?['refresh_token']?.toString(),
      tokenType: sessionData?['token_type']?.toString() ?? 'Bearer',
    );
  }
}
