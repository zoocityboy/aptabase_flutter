import 'dart:convert';

/// Extension on [Map] and [List] class providing additional functionality.
extension JsonX on Map {
  /// Parses the JSON string and returns the resulting [Map].
  String pretty() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(this);
  }
}

/// Extension on [List] class providing additional functionality.
extension JsonXList on List<Map> {
  /// Parses the JSON string and returns the resulting [List].
  String prettyJson() {
    return const JsonEncoder.withIndent('  ').convert(this);
  }
}
