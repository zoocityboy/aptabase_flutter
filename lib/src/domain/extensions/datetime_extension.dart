/// Extension on [DateTime] class providing additional functionality.
extension DateTimeX on DateTime {
  /// Returns the current UTC [DateTime].
  static DateTime get now => DateTime.now().toUtc();

  /// Converts the [DateTime] to an ISO 8601 formatted [String].
  String toIso8601String() {
    return toUtc().toIso8601String();
  }
}
