import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import '../../core/aptabase_constants.dart';

/// Extension method on [HttpClientRequest] to add headers.
///
/// This extension method adds the necessary headers to the [HttpClientRequest] object.
/// It sets the [headerAppKey] and [headerContentTypeHeader] headers using the provided [appKey].
/// Additionally, if the platform is not web, it sets the [userAgentHeader] using the [sdkVersion].
///
/// Example usage:
/// ```dart
/// HttpClientRequest request = ...;
/// request.addHeaders('your_app_key');
/// ```
extension HttpClientRequestX on HttpClientRequest {
  /// Adds the necessary headers to the [HttpClientRequest] object.
  void addHeaders(String appKey) {
    headers
      ..set(AptabaseConstants.headerAppKey, appKey)
      ..set(
        HttpHeaders.contentTypeHeader,
        AptabaseConstants.headerContentTypeValue,
      )
      ..set(HttpHeaders.contentEncodingHeader, 'gzip deflate compress');
    if (!kIsWeb) {
      headers.set(HttpHeaders.userAgentHeader, AptabaseConstants.sdkVersion);
    }
  }
}
