import 'dart:convert';

import 'package:universal_io/io.dart';

import '../domain.dart';

/// Represents an error response from the Aptabase API.
class AptabaseErrorResponse {
  /// Constructs an AptabaseErrorResponse instance.
  AptabaseErrorResponse({
    required this.type,
    required this.title,
    required this.status,
    required this.traceId,
    required this.errors,
  });

  /// Constructs an AptabaseErrorResponse instance from a map.
  factory AptabaseErrorResponse.fromMap(Map<String, dynamic> map) {
    return AptabaseErrorResponse(
      type: map['type'] as String,
      title: map['title'] as String,
      status: map['status'] as int,
      traceId: map['traceId'] as String,
      errors: AptabaseErrors.fromMap(map['errors'] as Map<String, dynamic>),
    );
  }

  /// Constructs an AptabaseErrorResponse instance from a JSON string.
  factory AptabaseErrorResponse.fromJson(String source) =>
      AptabaseErrorResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Type of the error.
  final String type;

  /// Title of the error.
  final String title;

  /// Status code of the error.
  final int status;

  /// Trace ID of the error.
  final String traceId;

  /// Errors associated with the error.
  final AptabaseErrors errors;

  /// Converts the AptabaseErrorResponse instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'title': title,
      'status': status,
      'traceId': traceId,
      'errors': errors.toMap(),
    };
  }

  /// Converts the AptabaseErrorResponse instance to a JSON string.
  String toJson() => json.encode(toMap());
}

/// Represents errors associated with the AptabaseErrorResponse.
class AptabaseErrors {
  /// Constructs an AptabaseErrors instance.
  AptabaseErrors({
    required this.events,
    required this.general,
  });

  /// Constructs an AptabaseErrors instance from a map.
  factory AptabaseErrors.fromMap(Map<String, dynamic> map) {
    return AptabaseErrors(
      events: List<String>.from(map['events'] as List<dynamic>),
      general: List<String>.from(map[r'$'] as List<dynamic>),
    );
  }

  /// Constructs an AptabaseErrors instance from a JSON string.
  factory AptabaseErrors.fromJson(String source) => AptabaseErrors.fromMap(json.decode(source) as Map<String, dynamic>);

  /// List of events related to the error.
  final List<String> events;

  /// General errors.
  final List<String> general;

  /// Converts the AptabaseErrors instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'events': events,
      r'$': general,
    };
  }

  /// Converts the AptabaseErrors instance to a JSON string.
  String toJson() => json.encode(toMap());
}

/// Extension on HttpClientResponse to provide additional functionality for handling Aptabase API responses.
extension HttpClientResponseX on HttpClientResponse {
  /// Reads the response as a string.
  Future<String> readAsString() => transform(utf8.decoder).join();

  /// Parses the response and constructs an AptabaseNetworkException.
  Future<AptabaseNetworkException> networkException() async {
    final content = await readAsString();
    final error = content.isEmpty ? null : AptabaseErrorResponse.fromJson(content);
    return AptabaseNetworkException(
      statusCode,
      reasonPhrase,
      error: error,
    );
  }
}
