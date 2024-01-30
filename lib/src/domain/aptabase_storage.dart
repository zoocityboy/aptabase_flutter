import '../infrastructure/logger.dart';
import 'model/event_item.dart';

/// An abstract class representing a storage interface for Aptabase.
abstract class AptabaseStorage {
  /// Creates a new [AptabaseStorage] instance.
  AptabaseStorage({
    required this.logger,
  });

  /// The logger.
  final Logger logger;

  /// A stream of values that notifies when the value of the storage changes.
  final Stream<int> onValueChanged = const Stream.empty();

  /// Writes an [EventItem] to the storage.
  ///
  /// Returns a [Future] that completes when the write operation is finished.
  Future<void> write(EventItem item);

  /// Reads an [EventItem] from the storage based on the given [index].
  ///
  /// Returns a [Future] that completes with the [EventItem] if found,
  /// or `null` if not found.
  Future<EventItem?> read(int index);

  /// Deletes an [EventItem] from the storage based on the given [index].
  ///
  /// Returns a [Future] that completes when the delete operation is finished.
  Future<void> remove(int index);

  /// Deletes all [EventItem]s from the storage.
  Future<void> clear();

  /// Deletes a list of [EventItem]s from the storage.
  Future<void> removeOffset({int limit = 10, int offset = 0});

  /// Reads a list of [EventItem]s from the storage.
  ///
  /// The [limit] parameter specifies the maximum number
  /// of items to read (default is 10).
  ///
  /// The [offset] parameter specifies the starting index
  /// for reading items (default is 0).
  ///
  /// Returns a [Future] that completes with a list of [EventItem]s.
  Future<List<EventItem>> readOffset({int limit = 10, int offset = 0});

  /// Returns the number of [EventItem]s in the storage.
  int count();

  /// Closes the storage.
  void close();
}
