// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../core/aptabase_constants.dart';
import '../domain/aptabase_storage.dart';
import '../domain/error/aptabase_failure.dart';
import '../domain/model/storage_event_item.dart';
import '../core/logger.dart';

/// A typedef representing a function that sends data and returns a `Future<Result<Unit, AptabaseApiFailure>>`.
///
/// The `SendData` function takes a list of `StorageEventItem` data as input and returns a `Future` that resolves to a `Result` object.
/// The `Result` object represents the success or failure of the API call, where `Unit` represents a successful result and `AptabaseApiFailure` represents a failure.
typedef SendData = Future<Result<Unit, AptabaseApiFailure>> Function(
  List<StorageEventItem> data,
);

/// A class that handles batch processing of data.
///
/// The [BatchProcessor] class is responsible for processing data in batches using a timer.
/// It takes an [AptabaseStorage] instance, a [SendData] function, and optional parameters for configuring the batch processing behavior.
/// The [AptabaseStorage] instance is used to read and remove items from storage.
/// The [SendData] function is called to send the batch of items for processing.
///
/// The [BatchProcessor] starts a timer when the storage value changes.
/// The timer triggers the [flush] method, which reads a batch of items from storage and sends them using the [SendData] function.
/// If the send operation is successful, the items are removed from storage.
/// If the send operation fails, an error is logged.
///
/// The [BatchProcessor] also provides methods to manually force a flush and to manage the timer.
/// The [clearTimer] method cancels the timer and sets it to null.
/// The [startTimer] method starts the timer if it is not already running.
/// The timer will call the [flush] method and restart itself if there are items in the storage.
/// The [forceFlush] method immediately clears the timer, calls the [flush] method, and starts the timer again.
class BatchProcessor {
  final AptabaseStorage storage;
  BatchProcessor({
    required this.storage,
    required this.sendData,
    this.sheduledDelay = AptabaseConstants.defaultSheduledDelay,
    this.logger,
    this.maxExportBatchSize = AptabaseConstants.defaultMaxExportBatchSize,
  }) {
    storage.onValueChanged.listen((event) {
      logger?.debug('onValueChanged $event');
      startTimer();
    });
  }
  final int maxExportBatchSize;
  final Duration sheduledDelay;
  final Logger? logger;
  final SendData sendData;
  Timer? timer;

  /// Flushes the batch by sending the items to the server.
  ///
  /// This method retrieves a batch of items from the storage and sends them to the server using the `sendData` method.
  /// If the batch is not empty, the result of sending the data is checked. If successful, the items are removed from the storage.
  /// If there is a failure, an error message is logged.
  /// If the batch is empty, a message is logged indicating that there are no items to send.
  ///
  /// Throws an exception if an error occurs during the process.
  Future<void> flush() async {
    final items = await storage.readOffset(limit: maxExportBatchSize);
    if (items.isNotEmpty) {
      final result = await sendData(items);
      return result.fold(
        (success) async {
          logger?.info(
            'sendData success ${items.length} / $maxExportBatchSize items sent',
          );
          await storage.removeOffset(limit: maxExportBatchSize);
        },
        (failure) {
          logger?.error('sendData failed with error: $failure');
        },
      );
    } else {
      logger?.info('sendData: no items to send');
    }
  }

  /// Clears the timer and sets it to null.
  void clearTimer() {
    timer?.cancel();
    timer = null;
  }

  /// Starts the timer if it is not already running.
  /// The timer will call the `flush` method and restart itself if there are items in the storage.
  void startTimer() {
    if (timer != null) {
      return;
    }
    timer = Timer(sheduledDelay, () async {
      await flush();
      if (storage.count() > 0) {
        clearTimer();
        startTimer();
      }
    });
  }

  /// Forces an immediate flush by clearing the timer, calling the `flush` method, and starting the timer again.
  Future<void> forceFlush() async {
    clearTimer();
    await flush();
    startTimer();
  }
}
