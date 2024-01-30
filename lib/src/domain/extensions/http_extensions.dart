import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import '../../constants.dart';

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
      ..set(Constants.headerAppKey, appKey)
      ..set(
        HttpHeaders.contentTypeHeader,
        Constants.headerContentTypeValue,
      )
      ..set(HttpHeaders.contentEncodingHeader, 'gzip');
    if (!kIsWeb) {
      headers.set(HttpHeaders.userAgentHeader, Constants.sdkVersion);
    }
  }
}
