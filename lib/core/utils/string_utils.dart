extension StringExtensions on String {
  /// Converts an ISO country code (e.g. "EG") into its flag emoji (🇪🇬)
  String get toFlagEmoji {
    if (length != 2) return '';
    return String.fromCharCodes(
      toUpperCase().codeUnits.map((char) => 0x1F1E6 + char - 0x41),
    );
  }
}
