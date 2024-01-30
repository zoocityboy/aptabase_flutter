// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'event_item.dart';

/// Represents the system properties of an event.
///
/// This class contains information about the device and application
/// properties at the time an event occurred. It is used to provide
/// context and additional details about the event.

@immutable
class EventSystemProperties {
  final bool isDebug;
  final String osName;
  final String osVersion;
  final String locale;
  final String appVersion;
  final String appBuildNumber;
  final String sdkVersion;
  const EventSystemProperties({
    required this.isDebug,
    required this.osName,
    required this.osVersion,
    required this.locale,
    required this.appVersion,
    required this.appBuildNumber,
    required this.sdkVersion,
  });

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
