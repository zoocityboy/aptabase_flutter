import 'package:flutter/foundation.dart';

import '../../core/aptabase_constants.dart';
import '../../core/aptabse_logger.dart';
import '../enum/aptabase_hosts.dart';
import '../error/aptabase_exception.dart';
import '../services/aptabase_storage.dart';

/// A callback function that logs the message and the object.
typedef AptabaseStorageBuilder = Future<AptabaseStorage> Function(AptabaseLogger logger);

/// Additional options for initializing the Aptabase SDK.
/// Represents the initialization options for the application.
///
/// The [AptabaseConfig] class is used to configure various options for the application initialization.
/// It includes properties such as [debug], [customBaseUrl], [sessionTimeout], [sheduledDelay], and [host].
///
/// The [debug] property indicates whether the application is running in debug mode or not.
///
/// The [customBaseUrl] property allows specifying a custom base URL for the application.
///
/// The [sessionTimeout] property represents the duration after which a session will be considered timed out.
///
/// The [sheduledDelay] property represents the duration after which the data will be flushed to the server.
///
/// The [host] property represents the host enum value that determines the server to connect to.
///
/// The [baseUrl] property returns the base URL to be used for API requests based on the [customBaseUrl] and [host] properties.
/// If [customBaseUrl] is specified and [host] is [AptabaseHosts.sh], the [customBaseUrl] will be used.
/// Otherwise, the URL from the [host] enum value will be used.
///
@immutable
class AptabaseConfig {
  /// Creates a new instance of [AptabaseConfig].
  const AptabaseConfig({
    required this.appKey,
    this.customBaseUrl,
    this.debug = false,
    this.sessionTimeout = AptabaseConstants.defaultSessionTimeout,
    this.sheduledDelay = AptabaseConstants.defaultSheduledDelay,
    this.maxExportBatchSize = AptabaseConstants.defaultMaxExportBatchSize,
    this.storageBuilder,
    this.logCallback,
  });

  /// The app key for the application.
  final String appKey;

  /// Indicates whether the application is running in debug mode or not.
  final bool debug;

  /// The custom base URL for the application.
  final String? customBaseUrl;

  /// The duration after which a session will be considered timed out.
  final Duration sessionTimeout;

  /// The duration after which the data will be flushed to the server.
  final Duration sheduledDelay;

  /// The maximum export batch size.
  final int maxExportBatchSize;

  /// The storage builder function.
  final AptabaseStorageBuilder? storageBuilder;

  /// The log callback function.
  final AptabaseLogCallback? logCallback;

  // coverage:ignore-start
  @override
  bool operator ==(covariant AptabaseConfig other) {
    if (identical(this, other)) return true;
    return other.appKey == appKey &&
        other.debug == debug &&
        other.customBaseUrl == customBaseUrl &&
        other.sessionTimeout == sessionTimeout &&
        other.sheduledDelay == sheduledDelay &&
        other.maxExportBatchSize == maxExportBatchSize &&
        other.storageBuilder == storageBuilder;
  }

  @override
  int get hashCode {
    return appKey.hashCode ^
        debug.hashCode ^
        customBaseUrl.hashCode ^
        sessionTimeout.hashCode ^
        sheduledDelay.hashCode ^
        maxExportBatchSize.hashCode ^
        storageBuilder.hashCode;
  }
  // coverage:ignore-end

  /// Validates the app key.
  bool validateKey() {
    final parts = appKey.split('-');
    if (parts.isEmpty || parts.length != 3) {
      throw const AptabaseInvalidAppKeyException();
    }
    return true;
  }

  /// Returns the host enum value based on the app key.
  AptabaseHosts get host => AptabaseHosts.values.firstWhere(
        (e) => e.name.toLowerCase() == appKey.split('-')[1].toLowerCase(),
      );

  /// Returns the base URL to be used for API requests.
  Uri? get baseUrl {
    if (customBaseUrl != null && host == AptabaseHosts.sh) {
      return Uri.parse(customBaseUrl!);
    } else {
      return Uri.parse(host.url);
    }
  }
}
