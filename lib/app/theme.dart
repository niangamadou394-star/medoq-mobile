import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedoqColors {
  // Primary
  static const Color primaryNavy = Color(0xFF1A3C5E);
  static const Color cyanAccent = Color(0xFF00B4D8);
  static const Color lightBlueBg = Color(0xFFE6F1FB);

  // Status
  static const Color greenAvailable = Color(0xFF2DC653);
  static const Color orangeLimited = Color(0xFFF4A261);
  static const Color redError = Color(0xFFE24B4A);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Border
  static const Color border = Color(0xFFE2E8F0);

  // White
  static const Color white = Color(0xFFFFFFFF);
}

class MedoqTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: MedoqColors.primaryNavy,
      primary: MedoqColors.primaryNavy,
      secondary: MedoqColors.cyanAccent,
      surface: MedoqColors.white,
      background: MedoqColors.background,
      error: MedoqColors.redError,
      onPrimary: MedoqColors.white,
      onSecondary: MedoqColors.white,
      onSurface: MedoqColors.textPrimary,
      onBackground: MedoqColors.textPrimary,
      onError: MedoqColors.white,
      brightness: Brightness.light,
    );

    final textTheme = GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: MedoqColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: MedoqColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: MedoqColors.textPrimary,
        ),
        headlineLarge: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: MedoqColors.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: MedoqColors.textPrimary,
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MedoqColors.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MedoqColors.textPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: MedoqColors.textPrimary,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MedoqColors.textPrimary,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: MedoqColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MedoqColors.textPrimary,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: MedoqColors.textSecondary,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MedoqColors.textPrimary,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: MedoqColors.textSecondary,
        ),
        labelSmall: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: MedoqColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: MedoqColors.background,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: MedoqColors.primaryNavy,
        foregroundColor: MedoqColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MedoqColors.white,
        ),
        iconTheme: const IconThemeData(color: MedoqColors.white),
        actionsIconTheme: const IconThemeData(color: MedoqColors.white),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MedoqColors.primaryNavy,
          foregroundColor: MedoqColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MedoqColors.primaryNavy,
          side: const BorderSide(color: MedoqColors.primaryNavy, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MedoqColors.primaryNavy,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MedoqColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MedoqColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MedoqColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MedoqColors.primaryNavy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MedoqColors.redError, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MedoqColors.redError, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 15,
          color: MedoqColors.textSecondary,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: MedoqColors.textSecondary,
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: MedoqColors.redError,
        ),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: MedoqColors.white,
        elevation: 2,
        shadowColor: Color(0x1A1A3C5E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.zero,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: MedoqColors.white,
        selectedItemColor: MedoqColors.primaryNavy,
        unselectedItemColor: MedoqColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: MedoqColors.surface,
        selectedColor: MedoqColors.lightBlueBg,
        side: const BorderSide(color: MedoqColors.border),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: MedoqColors.border,
        thickness: 1,
        space: 0,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MedoqColors.primaryNavy,
        foregroundColor: MedoqColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: MedoqColors.textPrimary,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: MedoqColors.white,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: MedoqColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: MedoqColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: MedoqColors.textSecondary,
        ),
      ),

      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MedoqColors.primaryNavy,
        circularTrackColor: MedoqColors.lightBlueBg,
      ),
    );
  }
}
