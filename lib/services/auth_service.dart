import '../models/user.dart';
import '../shared/utils/constants.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _client;

  AuthService({ApiClient? client}) : _client = client ?? apiClient;

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'phone': phone, 'password': password},
    );

    final accessToken = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String;
    final user = User.fromJson(data['user'] as Map<String, dynamic>);

    await Future.wait([
      StorageService.saveAccessToken(accessToken),
      StorageService.saveRefreshToken(refreshToken),
      StorageService.saveUser(user),
    ]);

    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    String? email,
    required String password,
  }) async {
    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
      },
    );

    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;
    final user = data['user'] != null
        ? User.fromJson(data['user'] as Map<String, dynamic>)
        : null;

    if (accessToken != null) {
      await StorageService.saveAccessToken(accessToken);
    }
    if (refreshToken != null) {
      await StorageService.saveRefreshToken(refreshToken);
    }
    if (user != null) {
      await StorageService.saveUser(user);
    }

    return data;
  }

  Future<void> forgotPassword({required String phone}) async {
    await _client.post<dynamic>(
      ApiEndpoints.forgotPassword,
      data: {'phone': phone},
    );
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await _client.post<dynamic>(
      ApiEndpoints.resetPassword,
      data: {
        'phone': phone,
        'otp': otp,
        'new_password': newPassword,
      },
    );
  }

  Future<void> refreshToken() async {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken == null) {
      throw const MedoqException(message: 'Aucun token de rafraîchissement');
    }

    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    await StorageService.saveAccessToken(data['access_token'] as String);
    if (data['refresh_token'] != null) {
      await StorageService.saveRefreshToken(data['refresh_token'] as String);
    }
  }

  Future<void> logout() async {
    try {
      await _client.post<dynamic>(ApiEndpoints.logout);
    } catch (_) {
      // Ignore errors during logout
    } finally {
      await StorageService.clearAll();
    }
  }

  Future<User> getCurrentUser() async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.currentUser,
    );
    final user = User.fromJson(data);
    await StorageService.saveUser(user);
    return user;
  }

  Future<bool> isAuthenticated() async {
    final token = await StorageService.getAccessToken();
    return token != null;
  }
}
