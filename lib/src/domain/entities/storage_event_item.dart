// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/aptabase_constants.dart';
import '../../core/sys_info.dart';
import '../../data/helpers/session.dart';
import '../extensions/datetime_extension.dart';

part 'event_system_properties.dart';

/// Represents an event item in the application.
///
/// An event item contains information about an event that occurred in the application,
/// such as the event name, properties, timestamp, session ID, and system properties.
@immutable
class StorageEventItem {
  final String eventName;
  final Map<String, dynamic>? props;
  final DateTime timestamp;
  final String sessionId;
  final EventSystemProperties systemProperties;

  /// Constructs a new [StorageEventItem] instance.
  ///
  /// The [eventName] parameter is required and represents the name of the event.
  /// The [props] parameter is optional and represents additional properties associated with the event.
  /// The [timestamp] parameter is required and represents the timestamp when the event occurred.
  /// The [sessionId] parameter is required and represents the ID of the session when the event occurred.
  /// The [systemProperties] parameter is required and represents the system properties associated with the event.
  const StorageEventItem({
    required this.eventName,
    required this.timestamp,
    required this.sessionId,
    required this.systemProperties,
    this.props,
  });

  /// Constructs a new [StorageEventItem] instance using the provided parameters.
  ///
  /// The [session] parameter is required and represents the Aptabase session.
  /// The [systemInfo] parameter is required and represents the system information.
  /// The [eventName] parameter is required and represents the name of the event.
  /// The [props] parameter is optional and represents additional properties associated with the event.
  factory StorageEventItem.create({
    required AptabaseSession session,
    required SystemInfo systemInfo,
    required String eventName,
    Map<String, dynamic>? props,
  }) {
    final eventSystemProperties = EventSystemProperties(
      isDebug: kDebugMode,
      osName: systemInfo.osName,
      osVersion: systemInfo.osVersion,
      locale: systemInfo.locale,
      appVersion: systemInfo.appVersion,
      appBuildNumber: systemInfo.buildNumber,
      sdkVersion: AptabaseConstants.sdkVersion,
    );
    return StorageEventItem(
      eventName: eventName,
      props: props,
      systemProperties: eventSystemProperties,
      timestamp: DateTimeX.now,
      sessionId: session.evalSessionId(),
    );
  }
  // coverage:ignore-start
  @override
  bool operator ==(covariant StorageEventItem other) {
    if (identical(this, other)) return true;

    return other.eventName == eventName &&
        mapEquals(other.props, props) &&
        other.timestamp == timestamp &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^ props.hashCode ^ timestamp.hashCode ^ sessionId.hashCode;
  }
  // coverage:ignore-end

  @override
  String toString() {
    return '''
EventItem(
  eventName: $eventName, 
  props: $props, 
  timestamp: $timestamp, 
  sessionId: $sessionId, 
  systemProperties: $systemProperties
)''';
  }

  /// Converts the [StorageEventItem] to a JSON string representation.
  Map<String, dynamic> toMap({bool redact = false}) {
    return <String, dynamic>{
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
      'eventName': eventName,
      'systemProps': redact ? '...' : systemProperties.toMap(),
      'props': props,
    };
  }

  String toJson() => json.encode(toMap());

  /// Returns a pretty-printed JSON string representation of the [StorageEventItem].
  String prettyJson() => const JsonEncoder.withIndent('  ').convert(
        toMap(
          redact: true,
        ),
      );
}
