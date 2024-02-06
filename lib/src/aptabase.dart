// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

import 'core/core.dart';
import 'data/data.dart';
import 'domain/domain.dart';

/// Aptabase Client for Flutter
///
/// Initialize the client with `Aptabase.init(appKey)` and then use `Aptabase.instance.trackEvent(eventName, props)` to record events.
class Aptabase {
  /// Initialize the logger, session, client, storage and processor.
  Aptabase._(
    AptabaseConfig config,
    SystemInfo sysInfo, {
    required this.logger,
    required this.storage,
  }) {
    session = AptabaseSession(sessionTimeout: config.sessionTimeout);
    client = AptabaseApiClient(
      baseUrl: config.baseUrl.toString(),
      appKey: config.appKey,
    );

    processor = BatchProcessor(
      storage: storage,
      sendData: sendData,
      logger: logger,
      maxExportBatchSize: config.maxExportBatchSize,
      sheduledDelay: config.sheduledDelay,
    );
    systemInfo = sysInfo;
    initConnectivity();
  }
  late final AptabaseLogger logger;
  late final AptabaseClient client;
  late final AptabaseSession session;
  late final AptabaseStorage storage;
  late final Connectivity connectivity;
  late final SystemInfo systemInfo;
  final ValueNotifier<bool> isConnected = ValueNotifier(true);
  late final BatchProcessor processor;

  @protected
  @visibleForTesting
  late final StreamSubscription<ConnectivityResult>? connectivitySubscription;

  static Aptabase? _instance;

  static Aptabase get instance {
    if (_instance == null) {
      throw const AptabaseNotInitializedException();
    }
    return _instance!;
  }

  @protected
  Future<Result<Unit, AptabaseHttpFailure>> sendData(List<StorageEventItem> items) async {
    if (!isConnected.value) {
      logger.error('sendData: no internet connection');
      return const Failure(OfflineHttpFailure());
    }
    final result = await client.sendEvents(items);
    return result;
  }

  void initConnectivity() {
    connectivity = Connectivity()
      ..checkConnectivity().then((value) {
        isConnected.value = value != ConnectivityResult.none;
      });
    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (event) {
        /// if the previous state was not connected and the current state is connected, force flush the processor.
        final previousState = isConnected.value;
        isConnected.value = event != ConnectivityResult.none;
        if (isConnected.value && !previousState) {
          processor.startTimer();
        }
      },
      onError: (e) {
        isConnected.value = false;
      },
    );
  }

  /// Closes the connection to the Aptabase server.
  /// and storage.
  void close() {
    storage.close();
    connectivitySubscription?.cancel();
  }

  /// Initializes the Aptabase SDK with the given appKey.
  static Future<Result<Aptabase, AptabaseFailure>> init(
    AptabaseConfig config,
  ) async {
    try {
      config.validateKey();
      final logger = AptabaseLogger(
        isDebug: config.debug,
        logCallback: config.logCallback,
      );
      final sysInfo = await SystemInfo.get();
      final storage = await config.storageBuilder?.call(logger) ?? AptabaseInMemoryStorage(logger);

      _instance = Aptabase._(
        config,
        sysInfo,
        storage: storage,
        logger: logger,
      );
      return Success(_instance!);
    } on AptabaseException catch (e) {
      return Failure(AptabaseExceptionFailure(e));
    }
  }

  /// Records an event with the given name and optional properties.
  Future<void> trackCustomEvent(
    String eventName, [
    Map<String, dynamic>? props,
  ]) =>
      storage.write(
        StorageEventItem.create(
          eventName: eventName,
          props: props,
          session: session,
          systemInfo: systemInfo,
        ),
      );

  Future<void> trackEvent(
    AptabaseTrackEvent event,
  ) {
    final data = StorageEventItem.create(
      eventName: event.eventName,
      props: event.props,
      session: session,
      systemInfo: systemInfo,
    );
    return storage.write(data);
  }

  Future<void> flush() async {
    await processor.flush();
  }

  @override
  String toString() {
    return 'Aptabase(logger: $logger, client: $client, session: $session, storage: $storage, connectivity: $connectivity, systemInfo: $systemInfo, processor: $processor, connectivitySubscription: $connectivitySubscription)';
  }
}
