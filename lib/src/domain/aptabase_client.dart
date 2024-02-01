import 'package:result_dart/result_dart.dart';
import 'package:universal_io/io.dart';

import 'error/aptabase_failure.dart';
import 'model/storage_event_item.dart';

/// Represents an abstract interface for an Aptabase client.
/// This interface defines methods for creating requests,
/// tracking events, and sending events.
abstract interface class AptabaseClient {
  /// Creates an HTTP client request for the specified [path].
  Future<HttpClientRequest> createRequest(String path);

  /// Tracks a single [eventItem] and returns the result as a [Result] object.
  Future<Result<Unit, AptabaseApiFailure>> trackEvent(StorageEventItem eventItem);

  /// Sends a list of [eventItems] and returns the result as a [Result] object.
  Future<Result<Unit, AptabaseApiFailure>> sendEvents(
    List<StorageEventItem> eventItems,
  );
}
