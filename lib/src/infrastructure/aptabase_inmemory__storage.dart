import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/aptabase_storage.dart';
import '../domain/model/storage_event_item.dart';
import '../core/logger.dart';

///
class AptabaseInMemoryStorage implements AptabaseStorage {
  ///
  AptabaseInMemoryStorage(
    this.logger,
  ) {
    onValueChanged.listen((event) {
      logger.debug('onValueChanged $event');
    });
  }
  final StreamController<int> _counterStreamController = StreamController<int>.broadcast();
  @override
  final Logger logger;

  ///
  @protected
  final Map<int, StorageEventItem> storage = {};

  @override
  Future<void> remove(int id) async {
    if (storage.containsKey(id)) {
      storage.remove(id);
      logger.info('remove: event item with id: $id removed', object: id);
    } else {
      logger.error('remove: event item with id: $id not found.');
    }
  }

  @override
  Future<StorageEventItem?> read(int id) async {
    if (storage.containsKey(id)) {
      final item = storage[id];
      logger.info('read: event item $item', object: item);
      return item;
    } else {
      logger.error('read: event item with id: $id not found.');
    }

    return null;
  }

  @override
  Future<List<StorageEventItem>> readOffset({int limit = 10, int offset = 0}) async {
    final items = storage.values.skip(offset).take(limit).toList();
    logger.info('readAll limit: $limit offset: $offset: $items', object: items);
    return items;
  }

  @override
  Future<void> write(StorageEventItem item) async {
    logger.info('write: event item', object: item);
    storage[storage.length] = item;
    _counterStreamController.add(count());
  }

  @override
  void close() {
    logger.info('close: storage closed');
    _counterStreamController.close();
  }

  @override
  int count() {
    logger.info('count: get count of items in storage');
    return storage.length;
  }

  @override
  Future<void> clear() async {
    storage.clear();
    logger.info('clear: storage cleared');
    _counterStreamController.add(count());
  }

  @override
  Future<void> removeOffset({int limit = 10, int offset = 0}) async {
    final items = storage.keys.skip(offset).take(limit).toList();
    storage.removeWhere((key, value) => items.contains(key));
    logger.info('removeOffset: removeOffset limit: $limit offset: $offset', object: items);
  }

  @override
  Stream<int> get onValueChanged => _counterStreamController.stream;
}
