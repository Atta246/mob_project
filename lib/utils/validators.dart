class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.trim().length > 20) {
      return 'Username must not exceed 20 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Email or Username validation (for login)
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or username is required';
    }

    if (value.trim().length < 3) {
      return 'Please enter a valid email or username';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Full name validation (First and Last name only)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    final trimmedValue = value.trim();
    final nameParts = trimmedValue.split(RegExp(r'\s+'));

    if (nameParts.length < 2) {
      return 'Please enter both first and last name';
    }

    if (nameParts.length > 2) {
      return 'Please enter only first and last name';
    }

    if (nameParts[0].length < 2) {
      return 'First name must be at least 2 characters';
    }

    if (nameParts[1].length < 2) {
      return 'Last name must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z]+$');
    if (!nameRegex.hasMatch(nameParts[0]) ||
        !nameRegex.hasMatch(nameParts[1])) {
      return 'Name can only contain letters';
    }

    return null;
  }

  // Username validation for profile completion
  static String? validateProfileUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (trimmedValue.length > 20) {
      return 'Username must not exceed 20 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(trimmedValue)) {
      return 'Only letters, numbers, and underscores allowed';
    }

    if (trimmedValue.contains(RegExp(r'\s'))) {
      return 'Username cannot contain spaces';
    }

    return null;
  }

  // Card number validation
  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'\s+'), '');

    if (cleaned.length != 16) {
      return 'Card number must be 16 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Card number must contain only digits';
    }

    return null;
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV is required';
    }

    if (value.length != 3 && value.length != 4) {
      return 'CVV must be 3 or 4 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain only digits';
    }

    return null;
  }

  // Expiry date validation (MM/YY)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required';
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!expiryRegex.hasMatch(value.trim())) {
      return 'Please enter date in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month);

    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Message validation (for contact/support)
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message is required';
    }

    if (value.trim().length < 10) {
      return 'Message must be at least 10 characters';
    }

    if (value.trim().length > 500) {
      return 'Message must not exceed 500 characters';
    }

    return null;
  }
}
