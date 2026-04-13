/// Convenience extensions on [String].
extension StringExtensions on String {
  /// Capitalises the first character: 'hello' → 'Hello'.
  String get capitalised {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalises every word: 'hello world' → 'Hello World'.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((w) => w.capitalised).join(' ');
  }

  /// Truncates to [maxLength] and appends an ellipsis if needed.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }

  /// Returns `null` if this string is empty; otherwise returns `this`.
  String? get nullIfEmpty => isEmpty ? null : this;
}
