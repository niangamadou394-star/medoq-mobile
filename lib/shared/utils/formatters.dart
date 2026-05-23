import 'package:intl/intl.dart';

class MedoqFormatters {
  static final NumberFormat _currencyFormat = NumberFormat('#,###', 'fr_FR');
  static final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
  static final DateFormat _dateTimeFormat =
      DateFormat('dd MMM yyyy à HH:mm', 'fr_FR');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'fr_FR');

  /// Format phone number as +221 XX XXX XX XX
  static String formatPhone(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    // Remove country code if present
    String localDigits = digits;
    if (digits.startsWith('221')) {
      localDigits = digits.substring(3);
    }

    // Ensure 9 digits
    if (localDigits.length != 9) return phone;

    // Format as XX XXX XX XX
    return '+221 ${localDigits.substring(0, 2)} ${localDigits.substring(2, 5)} ${localDigits.substring(5, 7)} ${localDigits.substring(7, 9)}';
  }

  /// Format raw phone input to local format XX XXX XX XX
  static String formatPhoneInput(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 9; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Format amount in FCFA: 3 500 FCFA
  static String formatAmount(double amount) {
    final formatted = _currencyFormat.format(amount.round());
    // Replace commas with spaces for French formatting
    return '${formatted.replaceAll(',', ' ')} FCFA';
  }

  /// Format amount without currency symbol
  static String formatAmountRaw(double amount) {
    final formatted = _currencyFormat.format(amount.round());
    return formatted.replaceAll(',', ' ');
  }

  /// Format distance: 1,2 km or 850 m
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      if (km == km.roundToDouble()) {
        return '${km.round()} km';
      }
      return '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
    }
    return '${meters.round()} m';
  }

  /// Format duration: 2h 30min or 45min
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      if (seconds > 0 && minutes < 5) {
        return '${minutes}min ${seconds}s';
      }
      return '${minutes}min';
    }
    return '${seconds}s';
  }

  /// Format countdown timer: 01:45:30
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /// Format date: 15 Mars 2024
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format datetime: 15 Mars 2024 à 14:30
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format time: 14:30
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Time ago: il y a 2h, il y a 3 jours
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Il y a $minutes min';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Il y a ${hours}h';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Il y a $days jour${days > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).round();
      return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return 'Il y a $months mois';
    }
    final years = (difference.inDays / 365).round();
    return 'Il y a $years an${years > 1 ? 's' : ''}';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
