// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../domain/aptabase_storage.dart';
import '../domain/error/aptabase_failure.dart';
import '../domain/model/event_item.dart';
import 'logger.dart';

typedef SendData = Future<Result<Unit, AptabaseApiFailure>> Function(
  List<EventItem> data,
);

class BatchProcessor {
  final AptabaseStorage storage;
  BatchProcessor({
    required this.storage,
    required this.sendData,
    this.sheduledDelay = const Duration(seconds: 10),
    this.logger,
    this.maxExportBatchSize = 100,
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

  void clearTimer() {
    timer?.cancel();
    timer = null;
  }

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

  Future<void> forceFlush() async {
    clearTimer();
    await flush();
    startTimer();
  }
}
