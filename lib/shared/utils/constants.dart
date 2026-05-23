class AppConstants {
  // API
  static const String apiBaseUrl = 'https://medoq-api.onrender.com/api/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Authentication
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Preferences
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String localeKey = 'locale';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Location
  static const double defaultLatitude = 14.6937; // Dakar, Senegal
  static const double defaultLongitude = -17.4441;
  static const double defaultZoom = 13.0;
  static const double pharmacyZoom = 15.0;

  // Search
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const List<int> radiusOptions = [1000, 3000, 5000, 10000]; // meters
  static const int defaultRadius = 3000;

  // Reservation
  static const Duration reservationExpiry = Duration(hours: 2);
  static const int maxQuantity = 10;
  static const double commissionRate = 0.02; // 2%

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;

  // Phone
  static const String phonePrefix = '+221';
  static const String phoneCountryCode = 'SN';

  // Pagination
  static const int pageSize = 20;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Map
  static const String googleMapsScheme = 'geo:';
  static const String wazeScheme = 'waze://';

  // Firebase
  static const String fcmTopic = 'all_patients';
}

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';

  static const String medications = '/medications';
  static const String popularMedications = '/medications/popular';

  static const String pharmacies = '/pharmacies';
  static const String nearbyPharmacies = '/pharmacies/nearby';

  static const String reservations = '/reservations';
  static String reservationById(String id) => '/reservations/$id';

  static const String initiateWave = '/payments/wave/initiate';
  static const String initiateOrangeMoney = '/payments/orange-money/initiate';
}
