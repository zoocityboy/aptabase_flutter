// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';

/// A typedef representing a function that sends data and returns a `Future<Result<Unit, AptabaseApiFailure>>`.
///
/// The `SendData` function takes a list of `StorageEventItem` data as input and returns a `Future` that resolves to a `Result` object.
/// The `Result` object represents the success or failure of the API call, where `Unit` represents a successful result and `AptabaseApiFailure` represents a failure.
typedef SendData = Future<Result<Unit, AptabaseHttpFailure>> Function(
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
/// The [restart] method immediately clears the timer, calls the [flush] method, and starts the timer again.
class BatchProcessor {
  final AptabaseStorage storage;
  static const String logTag = 'BatchProcessor';
  BatchProcessor({
    required this.storage,
    required this.sendData,
    required this.logger,
    required this.sheduledDelay,
    required this.maxExportBatchSize,
  }) {
    storage.onValueChanged.listen((event) {
      logger.info('onValueChanged $event');
      startTimer();
    });
  }
  final int maxExportBatchSize;
  final Duration sheduledDelay;
  final AptabaseLogger logger;
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
    logger.debug('flush', tag: logTag);
    final items = await storage.readOffset(limit: maxExportBatchSize);
    logger.debug('flush found ${items.length} items', tag: logTag);
    if (items.isNotEmpty) {
      final result = await sendData(items);
      return result.fold(
        (success) async {
          logger.info(
            'sendData success ${items.length} / $maxExportBatchSize items sent',
            tag: logTag,
          );
          await storage.removeOffset(limit: maxExportBatchSize);
        },
        (failure) {
          logger.error('sendData failed with error: $failure', tag: logTag);
        },
      );
    } else {
      logger.info('sendData: no items to send', tag: logTag);
    }
  }

  /// Clears the timer and sets it to null.
  void clearTimer() {
    logger.debug('clearTimer', tag: logTag);
    timer?.cancel();
    timer = null;
  }

  /// Starts the timer if it is not already running.
  /// The timer will call the `flush` method and restart itself if there are items in the storage.
  void startTimer() {
    logger.debug('startTimer isRunning[${timer != null}]', tag: logTag);
    if (timer != null) {
      return;
    }
    logger.debug('- create new timer with delay[$sheduledDelay]', tag: logTag);
    timer = Timer(sheduledDelay, () async {
      await flush();
      logger.debug('- count after flush: ${storage.count()}', tag: logTag);
      if (storage.count() > 0) {
        clearTimer();
        startTimer();
      }
    });
  }

  /// Forces an immediate flush by clearing the timer, calling the `flush` method, and starting the timer again.
  Future<void> restart() async {
    logger.debug('restart', tag: logTag);
    clearTimer();
    startTimer();
  }
}
