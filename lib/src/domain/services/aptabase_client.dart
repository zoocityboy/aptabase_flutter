import 'package:result_dart/result_dart.dart';

import '../entities/storage_event_item.dart';
import '../error/aptabase_failure.dart';

/// Represents an abstract interface for an Aptabase client.
/// This interface defines methods for creating requests,
/// tracking events, and sending events.
abstract interface class AptabaseClient {
  /// Creates an HTTP client request for the specified [path].
  Future<Unit> createRequest(String path, Object body);

  /// Tracks a single [eventItem] and returns the result as a [Result] object.
  Future<Result<Unit, AptabaseHttpFailure>> trackEvent(StorageEventItem eventItem);

  /// Sends a list of [eventItems] and returns the result as a [Result] object.
  Future<Result<Unit, AptabaseHttpFailure>> sendEvents(
    List<StorageEventItem> eventItems,
  );
}
