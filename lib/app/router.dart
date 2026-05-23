import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/home/screens/main_shell_screen.dart';
import '../features/search/screens/search_results_screen.dart';
import '../features/pharmacy/screens/pharmacy_detail_screen.dart';
import '../features/reservation/screens/reservation_screen.dart';
import '../features/reservation/screens/reservation_confirmation_screen.dart';
import '../features/payment/screens/payment_screen.dart';
import '../features/payment/screens/payment_success_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String searchResults = '/search-results';
  static const String pharmacyDetail = '/pharmacy/:id';
  static const String reservation = '/reservation/:pharmacyId/:medicationId';
  static const String reservationConfirm = '/reservation-confirm';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpScreen(phone: phone);
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainShellScreen(),
    ),
    GoRoute(
      path: AppRoutes.searchResults,
      builder: (context, state) {
        final query = state.extra as String? ?? '';
        return SearchResultsScreen(query: query);
      },
    ),
    GoRoute(
      path: AppRoutes.pharmacyDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PharmacyDetailScreen(pharmacyId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.reservation,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>? ?? {};
        return ReservationScreen(
          pharmacyId: state.pathParameters['pharmacyId'] ?? '',
          medicationId: state.pathParameters['medicationId'] ?? '',
          extra: params,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.reservationConfirm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return ReservationConfirmationScreen(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.payment,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return PaymentScreen(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.paymentSuccess,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return PaymentSuccessScreen(data: data);
      },
    ),
  ],
);
