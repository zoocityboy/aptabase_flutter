import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:flutter/material.dart';

/// This file contains the definition of the [EventKeys] class, which provides constant keys for events.
abstract class EventKeys {
  static const String incrementEventName = 'increment';
  static const String lifecycleEventKey = 'app_lifecycle';
}

/// Represents an event that increments a counter.
///
/// This event is used to track the increment action in the app.
/// It contains the current value of the counter as a property.
class IncrementEvent extends AptabaseTrackEvent {
  IncrementEvent(int counter)
      : super(
          eventName: EventKeys.incrementEventName,
          props: <String, Object>{"counter": counter},
        );
}

/// Represents a lifecycle event in the app.
///
/// This class extends the [AptabaseTrackEvent] class and provides a convenient way to track lifecycle events in the app.
/// It takes an [AppLifecycleState] as a parameter and creates an instance of [LifeCycleEvent] with the specified state.
/// The [eventName] is set to [EventKeys.lifecycleEventKey] and the [props] map contains the state as a string.
class LifeCycleEvent extends AptabaseTrackEvent {
  LifeCycleEvent(AppLifecycleState state)
      : super(
          eventName: EventKeys.lifecycleEventKey,
          props: <String, Object>{"state": state.toString()},
        );
}
