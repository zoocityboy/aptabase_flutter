// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../constants.dart';
import '../../infrastructure/session.dart';
import '../../infrastructure/sys_info.dart';
import '../extensions/datetime_extension.dart';

part 'event_system_properties.dart';

/// Represents an event item in the application.
///
/// An event item contains information about an event that occurred in the application,
/// such as the event name, properties, timestamp, session ID, and system properties.
@immutable
class EventItem {
  final String eventName;
  final Map<String, dynamic>? props;
  final DateTime timestamp;
  final String sessionId;
  final EventSystemProperties systemProperties;

  /// Constructs a new [EventItem] instance.
  ///
  /// The [eventName] parameter is required and represents the name of the event.
  /// The [props] parameter is optional and represents additional properties associated with the event.
  /// The [timestamp] parameter is required and represents the timestamp when the event occurred.
  /// The [sessionId] parameter is required and represents the ID of the session when the event occurred.
  /// The [systemProperties] parameter is required and represents the system properties associated with the event.
  const EventItem({
    required this.eventName,
    required this.timestamp,
    required this.sessionId,
    required this.systemProperties,
    this.props,
  });

  /// Constructs a new [EventItem] instance using the provided parameters.
  ///
  /// The [session] parameter is required and represents the Aptabase session.
  /// The [systemInfo] parameter is required and represents the system information.
  /// The [eventName] parameter is required and represents the name of the event.
  /// The [props] parameter is optional and represents additional properties associated with the event.
  factory EventItem.create({
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
      sdkVersion: Constants.sdkVersion,
    );
    return EventItem(
      eventName: eventName,
      props: props,
      systemProperties: eventSystemProperties,
      timestamp: DateTimeX.now,
      sessionId: session.evalSessionId(),
    );
  }

  @override
  bool operator ==(covariant EventItem other) {
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

  /// Converts the [EventItem] to a JSON string representation.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
      'eventName': eventName,
      'systemProps': systemProperties.toMap(),
      'props': props,
    };
  }

  String toJson() => json.encode(toMap());
}
