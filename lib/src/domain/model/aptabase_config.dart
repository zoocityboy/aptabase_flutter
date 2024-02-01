// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../core/aptabase_constants.dart';
import '../../core/logger.dart';
import '../aptabase_storage.dart';
import '../enum/aptabase_hosts.dart';
import '../error/aptabase_exception.dart';

/// Additional options for initializing the Aptabase SDK.
/// Represents the initialization options for the application.
///
/// The [AptabasConfig] class is used to configure various options for the application initialization.
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
typedef AptabaseStorageBuilder = Future<AptabaseStorage> Function(Logger logger);

@immutable
class AptabasConfig {
  final String appKey;
  final bool debug;
  final String? customBaseUrl;
  final Duration sessionTimeout;
  final Duration sheduledDelay;
  final int maxExportBatchSize;
  final AptabaseStorageBuilder? storageBuilder;

  const AptabasConfig({
    required this.appKey,
    this.customBaseUrl,
    this.debug = false,
    this.sessionTimeout = AptabaseConstants.defaultSessionTimeout,
    this.sheduledDelay = AptabaseConstants.defaultSheduledDelay,
    this.maxExportBatchSize = AptabaseConstants.defaultMaxExportBatchSize,
    this.storageBuilder,
  });

  @override
  bool operator ==(covariant AptabasConfig other) {
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

  /// Validates the app key.
  bool validateKey() {
    final parts = appKey.split('-');
    if (parts.isEmpty || parts.length != 3) {
      throw const AppKeyInvalidException();
    }
    return true;
  }

  /// Returns the host enum value based on the app key.
  AptabaseHosts get host => AptabaseHosts.values.firstWhere(
        (e) => e.name.toLowerCase() == appKey.split('-')[1].toLowerCase(),
      );

  Uri? get baseUrl {
    if (customBaseUrl != null && host == AptabaseHosts.sh) {
      return Uri.parse(customBaseUrl!);
    } else {
      return Uri.parse(host.url);
    }
  }
}
