part of 'storage_event_item.dart';

/// Represents the system properties of an event.
///
/// This class contains information about the device and application
/// properties at the time an event occurred. It is used to provide
/// context and additional details about the event.

@immutable
class EventSystemProperties {
  /// Constructs a new [EventSystemProperties] instance.
  const EventSystemProperties({
    required this.isDebug,
    required this.osName,
    required this.osVersion,
    required this.locale,
    required this.appVersion,
    required this.appBuildNumber,
    required this.sdkVersion,
  });

  /// Indicates whether the application is running in debug mode or not.
  final bool isDebug;

  /// The name of the operating system.
  final String osName;

  /// The version of the operating system.
  final String osVersion;

  /// The locale of the operating system.
  final String locale;

  /// The version of the application.
  final String appVersion;

  /// The build number of the application.
  final String appBuildNumber;

  /// The version of the SDK.
  final String sdkVersion;

  // coverage:ignore-start
  @override
  bool operator ==(covariant EventSystemProperties other) {
    if (identical(this, other)) return true;

    return other.isDebug == isDebug &&
        other.osName == osName &&
        other.osVersion == osVersion &&
        other.locale == locale &&
        other.appVersion == appVersion &&
        other.appBuildNumber == appBuildNumber &&
        other.sdkVersion == sdkVersion;
  }

  @override
  int get hashCode {
    return isDebug.hashCode ^
        osName.hashCode ^
        osVersion.hashCode ^
        locale.hashCode ^
        appVersion.hashCode ^
        appBuildNumber.hashCode ^
        sdkVersion.hashCode;
  }
  // coverage:ignore-end

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isDebug': isDebug,
      'osName': osName,
      'osVersion': osVersion,
      'locale': locale,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
      'sdkVersion': sdkVersion,
    };
  }

  String toJson() => json.encode(toMap());

  /// Returns a pretty-printed JSON string representation of the [EventSystemProperties].
  String prettyJson() => const JsonEncoder.withIndent('  ').convert(toMap());

  @override
  String toString() {
    return '''
EventSystemProperties(
  isDebug: $isDebug, 
  osName: $osName, 
  osVersion: $osVersion, 
  locale: $locale, 
  appVersion: $appVersion, 
  appBuildNumber: $appBuildNumber, 
  sdkVersion: $sdkVersion
)''';
  }
}
