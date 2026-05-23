import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../shared/utils/constants.dart';

class StorageService {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ───── Secure Token Storage ─────

  static Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
        key: AppConstants.accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
        key: AppConstants.refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.accessTokenKey),
      _secureStorage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }

  // ───── User Data ─────

  static Future<void> saveUser(User user) async {
    await _secureStorage.write(
        key: AppConstants.userKey, value: jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final data = await _secureStorage.read(key: AppConstants.userKey);
    if (data == null) return null;
    try {
      return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await _secureStorage.delete(key: AppConstants.userKey);
  }

  // ───── Preferences ─────

  static bool get onboardingCompleted =>
      _prefs?.getBool(AppConstants.onboardingCompletedKey) ?? false;

  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs?.setBool(AppConstants.onboardingCompletedKey, value);
  }

  static bool get notificationsEnabled =>
      _prefs?.getBool(AppConstants.notificationsEnabledKey) ?? true;

  static Future<void> setNotificationsEnabled(bool value) async {
    await _prefs?.setBool(AppConstants.notificationsEnabledKey, value);
  }

  static String get locale => _prefs?.getString(AppConstants.localeKey) ?? 'fr';

  static Future<void> setLocale(String locale) async {
    await _prefs?.setString(AppConstants.localeKey, locale);
  }

  // ───── Clear All ─────

  static Future<void> clearAll() async {
    await Future.wait([
      clearTokens(),
      clearUser(),
      _prefs?.clear() ?? Future.value(),
    ]);
  }
}
