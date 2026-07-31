import 'package:flutter/services.dart';

/// Custom input formatters for text fields
class AppInputFormatters {
  // Private constructor
  AppInputFormatters._();

  /// Only allows letters and spaces (for names)
  static final lettersOnly = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\s]'),
  );

  /// Only allows numbers (integers)
  static final numbersOnly = FilteringTextInputFormatter.digitsOnly;

  /// Only allows numbers with decimal point
  static final decimalNumbers = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d*'),
  );

  /// Only allows alphanumeric characters
  static final alphanumeric = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9]'),
  );

  /// Only allows alphanumeric with spaces
  static final alphanumericWithSpaces = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9\s]'),
  );

  /// Phone number formatter (numbers, +, -, spaces)
  static final phoneNumber = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9+\-\s]'),
  );

  /// Plate number formatter (letters, numbers, dash)
  static final plateNumber = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9\-]'),
  );

  /// Email formatter (no spaces)
  static final email = FilteringTextInputFormatter.deny(RegExp(r'\s'));

  /// Price formatter with 2 decimal places
  static List<TextInputFormatter> priceFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
  ];

  /// Ethiopian phone number formatter
  static List<TextInputFormatter> ethiopianPhoneFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
    LengthLimitingTextInputFormatter(15), // +251912345678
  ];

  /// Name formatters
  static List<TextInputFormatter> nameFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
    LengthLimitingTextInputFormatter(50),
  ];

  /// Description formatters
  static List<TextInputFormatter> descriptionFormatters = [
    LengthLimitingTextInputFormatter(500),
  ];

  /// Integer formatters
  static List<TextInputFormatter> integerFormatters = [
    FilteringTextInputFormatter.digitsOnly,
  ];

  /// Decimal formatters (for prices, weights, etc.)
  static List<TextInputFormatter> decimalFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
  ];

  /// Year formatters
  static List<TextInputFormatter> yearFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];

  /// Plate number formatters
  static List<TextInputFormatter> plateNumberFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
    LengthLimitingTextInputFormatter(10),
    UpperCaseTextFormatter(),
  ];

  /// Email formatters
  static List<TextInputFormatter> emailFormatters = [
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(100),
  ];
}

/// Custom formatter to convert text to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Custom formatter for Ethiopian phone numbers with auto-formatting
class EthiopianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove all non-digit characters except +
    String cleaned = text.replaceAll(RegExp(r'[^\d+]'), '');

    // Limit length
    if (cleaned.length > 13) {
      cleaned = cleaned.substring(0, 13);
    }

    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}
