import 'package:meta/meta.dart';

import '../version.g.dart';

/// Aptabase SDK constants
@protected
class AptabaseConstants {
  /// The SDK version
  static const String sdkVersion = 'aptabase_flutter@$packageVersion';

  /// The AppKey header
  static const String headerAppKey = 'App-Key';

  /// The Content-Type value
  static const String headerContentTypeValue = 'application/json; charset=utf-8';

  /// Default value for max export batch size
  static const int defaultMaxExportBatchSize = 100;

  /// Default value for session timeout
  static const Duration defaultSessionTimeout = Duration(hours: 1);

  /// Default value for sheduled delay
  static const Duration defaultSheduledDelay = Duration(seconds: 10);
}

/// Aptabase SDK API paths
@protected
abstract class ApiPath {
  /// Track single event endpoint
  static const String single = '/api/v0/event';

  /// Track batch events endpoint
  static const String batch = '/api/v0/events';
}
