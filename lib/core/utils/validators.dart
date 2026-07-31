/// Comprehensive input validation utilities for the application
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Email validation
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

  /// Ethiopian phone number validation
  /// Accepts formats: +251912345678, 0912345678, 912345678
  static String? validateEthiopianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes
    final cleanedPhone = value.replaceAll(RegExp(r'[\s-]'), '');

    // Ethiopian phone number patterns
    final patterns = [
      RegExp(r'^\+251[79]\d{8}$'), // +251912345678
      RegExp(r'^0[79]\d{8}$'), // 0912345678
      RegExp(r'^[79]\d{8}$'), // 912345678
    ];

    final isValid = patterns.any((pattern) => pattern.hasMatch(cleanedPhone));

    if (!isValid) {
      return 'Please enter a valid Ethiopian phone number\n(e.g., +251912345678 or 0912345678)';
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Name validation (only letters and spaces)
  static String? validateName(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }

    if (value.trim().length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return '${fieldName ?? 'Name'} can only contain letters and spaces';
    }

    return null;
  }

  /// Number validation (positive numbers only)
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return '${fieldName ?? 'Value'} must be positive';
    }

    return null;
  }

  /// Integer validation
  static String? validateInteger(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid whole number';
    }

    if (number < 0) {
      return '${fieldName ?? 'Value'} must be positive';
    }

    return null;
  }

  /// Price/Amount validation
  static String? validatePrice(String? value, {double? minValue}) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }

    if (minValue != null && price < minValue) {
      return 'Price must be at least $minValue';
    }

    return null;
  }

  /// Weight validation (in kg or tons)
  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }

    final weight = double.tryParse(value.trim());
    if (weight == null) {
      return 'Please enter a valid weight';
    }

    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }

    return null;
  }

  /// Distance validation (in km)
  static String? validateDistance(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Distance is required';
    }

    final distance = double.tryParse(value.trim());
    if (distance == null) {
      return 'Please enter a valid distance';
    }

    if (distance <= 0) {
      return 'Distance must be greater than 0';
    }

    return null;
  }

  /// Plate number validation (Ethiopian format)
  static String? validatePlateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Plate number is required';
    }

    // Ethiopian plate format: 3-12345 or AA-12345
    final plateRegex = RegExp(r'^[A-Z0-9]{1,3}-\d{4,5}$', caseSensitive: false);

    if (!plateRegex.hasMatch(value.trim().toUpperCase())) {
      return 'Please enter a valid plate number (e.g., 3-12345 or AA-12345)';
    }

    return null;
  }

  /// Description validation
  static String? validateDescription(
    String? value, {
    int minLength = 10,
    int maxLength = 500,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < minLength) {
      return 'Description must be at least $minLength characters';
    }

    if (value.trim().length > maxLength) {
      return 'Description must not exceed $maxLength characters';
    }

    return null;
  }

  /// URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Date validation (must be in the future)
  static String? validateFutureDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    if (value.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  /// Date validation (must be in the past)
  static String? validatePastDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    if (value.isAfter(DateTime.now())) {
      return 'Date must be in the past';
    }

    return null;
  }

  /// Bid amount validation
  static String? validateBidAmount(String? value, {double? minBid}) {
    if (value == null || value.trim().isEmpty) {
      return 'Bid amount is required';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Bid amount must be greater than 0';
    }

    if (minBid != null && amount < minBid) {
      return 'Bid amount must be at least ${minBid.toStringAsFixed(2)} ETB';
    }

    return null;
  }

  /// Capacity validation (truck capacity in tons)
  static String? validateCapacity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Capacity is required';
    }

    final capacity = double.tryParse(value.trim());
    if (capacity == null) {
      return 'Please enter a valid capacity';
    }

    if (capacity <= 0) {
      return 'Capacity must be greater than 0';
    }

    if (capacity > 100) {
      return 'Capacity seems too high. Please verify.';
    }

    return null;
  }

  /// Year validation (for vehicle year)
  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Year is required';
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Please enter a valid year';
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear + 1) {
      return 'Please enter a valid year between 1900 and ${currentYear + 1}';
    }

    return null;
  }

  /// Message validation (for chat/bid messages)
  static String? validateMessage(String? value, {int minLength = 1}) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }

    if (value.trim().length < minLength) {
      return 'Message must be at least $minLength character(s)';
    }

    return null;
  }
}
