import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/aptabse_logger.dart';
import '../../domain/domain.dart';

///
class AptabaseInMemoryStorage implements AptabaseStorage {
  /// Constructor
  AptabaseInMemoryStorage(
    this.logger,
  ) {
    onValueChanged.listen((event) {
      logger.debug('onValueChanged $event');
    });
  }
  static const String logTag = 'AptabaseInMemoryStorage';
  final StreamController<int> _counterStreamController = StreamController<int>.broadcast();

  @override
  final AptabaseLogger logger;

  ///
  @protected
  final Map<int, StorageEventItem> storage = {};

  @override
  Future<void> remove(int id) async {
    if (storage.containsKey(id)) {
      storage.remove(id);
      logger.debug('remove: event item with id: $id removed', object: id, tag: logTag);
    } else {
      logger.error('remove: event item with id: $id not found.', tag: logTag);
    }
  }

  @override
  Future<StorageEventItem?> read(int id) async {
    if (storage.containsKey(id)) {
      final item = storage[id];
      logger.debug('read', object: item?.prettyJson(), tag: logTag);
      return item;
    } else {
      logger.error('read id: $id not found.', tag: logTag);
    }

    return null;
  }

  @override
  Future<List<StorageEventItem>> readOffset({int limit = 10, int offset = 0}) async {
    final items = storage.values.skip(offset).take(limit).toList();
    logger.debug('readOffset limit: $limit offset: $offset', object: items.map((e) => e.prettyJson()), tag: logTag);
    return items;
  }

  @override
  Future<void> write(StorageEventItem item) async {
    logger.debug('write: event item', object: item.prettyJson(), tag: logTag);
    storage[storage.length] = item;
    _counterStreamController.add(count());
  }

  @override
  void close() {
    logger.debug('close: storage closed', tag: logTag);
    _counterStreamController.close();
  }

  @override
  int count() {
    logger.debug('count: get count of items in storage [${storage.length}]', tag: logTag);
    return storage.length;
  }

  @override
  Future<void> clear() async {
    storage.clear();
    logger.debug('clear: storage cleared', tag: logTag);
    _counterStreamController.add(count());
  }

  @override
  Future<void> removeOffset({int limit = 10, int offset = 0}) async {
    final items = storage.keys.skip(offset).take(limit).toList();
    if (items.isEmpty) {
      return;
    }
    logger.debug('removeOffset: removeOffset limit: $limit offset: $offset', object: items, tag: logTag);
    if (offset == 0 && items.length == storage.length) {
      storage.clear();
    } else {
      storage.removeWhere((key, value) => items.contains(key));
    }

    _counterStreamController.add(count());
  }

  @override
  Stream<int> get onValueChanged => _counterStreamController.stream;
}
