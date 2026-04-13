/// Validation helpers used across forms and inputs.
abstract final class Validators {
  /// Returns an error string if [value] is null or empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Returns an error string if [value] is not a valid email.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Returns an error string if [value] is not a plausible ISBN-13.
  static String? isbn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ISBN is required.';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.length != 13 || !RegExp(r'^\d{13}$').hasMatch(cleaned)) {
      return 'Please enter a valid 13-digit ISBN.';
    }
    return null;
  }

  /// Returns an error string if [value] is not a positive integer.
  static String? positiveInt(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 1) {
      return '$fieldName must be a positive whole number.';
    }
    return null;
  }
}
