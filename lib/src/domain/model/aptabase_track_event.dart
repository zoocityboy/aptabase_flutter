/// Represents a track event.
///
/// This is an abstract class that defines the common properties of a track event.
/// It contains the [eventName] and optional [props] that can be used to provide additional information about the event.
///
/// ```dart
/// class CounterEvent extends AptabaseTrackEvent {
///   CounterEvent(int counter) : super(
///     eventName: 'counter_event',
///     props: {
///       'counter: counter,
///     },
///   );
/// }```
///
abstract class AptabaseTrackEvent {
  /// Constructs a new [AptabaseTrackEvent] instance.
  const AptabaseTrackEvent({
    required this.eventName,
    this.props,
  });

  /// Define [AptabaseTrackEvent] eventName.
  final String eventName;

  /// Event properties.
  final Map<String, Object>? props;
}
