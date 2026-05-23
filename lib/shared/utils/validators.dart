class MedoqValidators {
  /// Validate Senegalese phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final localDigits =
        digits.startsWith('221') ? digits.substring(3) : digits;

    if (localDigits.length != 9) {
      return 'Numéro invalide (9 chiffres requis)';
    }

    // Senegalese mobile numbers start with 7
    if (!localDigits.startsWith('7')) {
      return 'Numéro de mobile invalide (doit commencer par 7)';
    }

    return null;
  }

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Adresse email invalide';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  /// Validate password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.trim().length > 100) {
      return 'Le nom est trop long';
    }
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Le nom contient des caractères invalides';
    }
    return null;
  }

  /// Validate OTP
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le code OTP est requis';
    }
    if (value.trim().length != 6) {
      return 'Le code OTP doit contenir 6 chiffres';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Le code OTP doit être numérique';
    }
    return null;
  }

  /// Validate quantity
  static String? validateQuantity(String? value, {int max = 10}) {
    if (value == null || value.trim().isEmpty) {
      return 'La quantité est requise';
    }
    final quantity = int.tryParse(value.trim());
    if (quantity == null) {
      return 'Quantité invalide';
    }
    if (quantity < 1) {
      return 'La quantité doit être au moins 1';
    }
    if (quantity > max) {
      return 'La quantité ne peut pas dépasser $max';
    }
    return null;
  }
}
