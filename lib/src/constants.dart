import 'package:meta/meta.dart';

import 'version.g.dart';

/// Aptabase SDK constants
@protected
class Constants {
  /// The SDK version
  static const String sdkVersion = 'aptabase_flutter@$packageVersion';

  /// The AppKey header
  static const String headerAppKey = 'App-Key';

  /// The Content-Type value
  static const String headerContentTypeValue = 'application/json; charset=utf-8';
}

/// Aptabase SDK API paths
@protected
abstract class ApiPath {
  /// Track single event endpoint
  static const String single = '/api/v0/event';

  /// Track batch events endpoint
  static const String batch = '/api/v0/events';
}
