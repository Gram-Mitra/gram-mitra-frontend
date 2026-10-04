import '../core/constants/api_endpoints.dart';
import '../core/storage/storage_service.dart';
import '../models/auth_session.dart';
import '../models/user_profile.dart';
import 'api_service.dart';

class AuthService {
  /// Register new user strictly using database fields
  static Future<AuthSession?> register({
    required String password,
    String? phone,
    String? email,
    String? fullName,
    int? age,
    String? state,
    String? district,
    String? village,
  }) async {
    final payload = <String, dynamic>{
      'password': password,
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      if (email != null && email.trim().isNotEmpty) 'email': email.trim().toLowerCase(),
      if (fullName != null && fullName.trim().isNotEmpty) 'full_name': fullName.trim(),
      if (age != null && age > 0) 'age': age,
      if (state != null && state.trim().isNotEmpty) 'state': state.trim(),
      if (district != null && district.trim().isNotEmpty) 'district': district.trim(),
      if (village != null && village.trim().isNotEmpty) 'village': village.trim(),
    };

    final response = await ApiService.post(ApiEndpoints.authRegister, payload);

    if (response.success && response.data != null) {
      final session = AuthSession.fromJson(response.data as Map<String, dynamic>);
      if (session.accessToken != null) {
        await StorageService.setAuthToken(session.accessToken!);
      }
      await StorageService.setUserProfile(session.user);
      return session;
    }

    final errMsg = response.error ?? (response.message.isNotEmpty ? response.message : 'Registration failed');
    throw Exception(errMsg);
  }

  /// Login user using phone/email identifier and password
  static Future<AuthSession?> login({
    required String identifier,
    required String password,
  }) async {
    final payload = {
      'identifier': identifier.trim(),
      'password': password,
    };

    final response = await ApiService.post(ApiEndpoints.authLogin, payload);

    if (response.success && response.data != null) {
      final session = AuthSession.fromJson(response.data as Map<String, dynamic>);
      if (session.accessToken != null) {
        await StorageService.setAuthToken(session.accessToken!);
      }
      await StorageService.setUserProfile(session.user);
      return session;
    }

    final errMsg = response.error ?? (response.message.isNotEmpty ? response.message : 'Invalid credentials');
    throw Exception(errMsg);
  }

  /// Fetch currently authenticated user profile
  static Future<UserProfile?> getMe() async {
    final response = await ApiService.get(ApiEndpoints.authMe);

    if (response.success && response.data != null) {
      final data = response.data;
      final userMap = data is Map && data['user'] is Map ? data['user'] as Map<String, dynamic> : data as Map<String, dynamic>;
      final profile = UserProfile.fromJson(userMap);
      await StorageService.setUserProfile(profile);
      return profile;
    }

    return null;
  }

  /// Logout and clear local session
  static Future<void> logout() async {
    try {
      await ApiService.post(ApiEndpoints.authLogout, {});
    } catch (_) {}
    await StorageService.clearSession();
  }
}
