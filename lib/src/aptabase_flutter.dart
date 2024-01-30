/// The Flutter SDK for Aptabase, a privacy-first and simple analytics platform for apps.
// ignore_for_file: public_member_api_docs

library aptabase_flutter;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

import 'domain/aptabase_client.dart';
import 'domain/aptabase_storage.dart';
import 'domain/error/aptabase_exception.dart';
import 'domain/error/aptabase_failure.dart';
import 'domain/model/aptabase_config.dart';
import 'domain/model/event_item.dart';
import 'infrastructure/aptabase_api_client.dart';
import 'infrastructure/aptabase_inmemory__storage.dart';
import 'infrastructure/batch_processor.dart';
import 'infrastructure/logger.dart';
import 'infrastructure/session.dart';
import 'infrastructure/sys_info.dart';

/// Aptabase Client for Flutter
///
/// Initialize the client with `Aptabase.init(appKey)` and then use `Aptabase.instance.trackEvent(eventName, props)` to record events.
class Aptabase {
  /// Initialize the logger, session, client, storage and processor.
  Aptabase._(AptabasConfig config, SystemInfo sysInfo) {
    logger = Logger(isDebug: config.debug);
    session = AptabaseSession(sessionTimeout: config.sessionTimeout);
    client = AptabaseApiClient(
      baseUrl: config.baseUrl.toString(),
      appKey: config.appKey,
    );

    storage = AptabaseInMemoryStorage(logger);
    processor = BatchProcessor(
      storage: storage,
      sendData: (items) async {
        if (!isConnected.value) {
          logger.error('sendData: no internet connection');
          return const Failure(NoInternetApiFailure());
        }
        final result = await client.sendEvents(items);
        return result;
      },
      logger: logger,
      maxExportBatchSize: config.maxExportBatchSize,
      sheduledDelay: config.sheduledDelay,
    );
    systemInfo = sysInfo;
    initConnectivity();
  }
  late final Logger logger;
  late final AptabaseClient client;
  late final AptabaseSession session;
  late final AptabaseStorage storage;
  late final Connectivity connectivity;
  late final SystemInfo systemInfo;
  final ValueNotifier<bool> isConnected = ValueNotifier(false);
  late final BatchProcessor processor;
  @protected
  late final StreamSubscription<ConnectivityResult>? connectivitySubscription;

  static Aptabase? _instance;

  static Aptabase get instance {
    if (_instance == null) {
      throw const AptabaseNotInitializedException();
    }
    return _instance!;
  }

  void initConnectivity() {
    connectivity = Connectivity();
    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (event) {
        isConnected.value = event != ConnectivityResult.none;
      },
      onError: (e) {
        isConnected.value = false;
      },
    );
  }

  /// Closes the connection to the Aptabase server.
  void close() {
    storage.close();
    connectivitySubscription?.cancel();
  }

  /// Initializes the Aptabase SDK with the given appKey.
  static Future<Result<Aptabase, AptabaseFailure>> init(
    AptabasConfig config,
  ) async {
    try {
      config.validateKey();
      final sysInfo = await SystemInfo.get();

      _instance = Aptabase._(config, sysInfo);
      return Success(_instance!);
    } on AptabaseException catch (e) {
      return Failure(AptabaseFailure.tryParse(e));
    }
  }

  /// Records an event with the given name and optional properties.
  Future<void> trackEvent(
    String eventName, [
    Map<String, dynamic>? props,
  ]) async {
    final eventData = EventItem.create(
      eventName: eventName,
      props: props,
      session: session,
      systemInfo: systemInfo,
    );
    await storage.write(eventData);
  }

  Future<void> flush() async {
    await processor.flush();
  }
}
