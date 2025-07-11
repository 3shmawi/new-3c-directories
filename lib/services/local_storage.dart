import 'package:hive_flutter/hive_flutter.dart';

/// Singleton class
class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  bool _initialized = false;

  /// Initialize Hive and optionally register adapters
  Future<void> init({List<HiveAdapter>? adapters}) async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register custom type adapters
    if (adapters != null) {
      for (final adapter in adapters) {
        if (!Hive.isAdapterRegistered(adapter.typeId)) {
          Hive.registerAdapter(adapter.adapter);
        }
      }
    }

    _initialized = true;
  }

  /// Open or return an already opened box
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Get box if already open (null if not)
  Box<T>? getBox<T>(String boxName) {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return null;
  }

  /// Close a box safely
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Delete a box (if you want to reset it)
  Future<void> deleteBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }
}

class HiveAdapter<T> {
  final int typeId;
  final TypeAdapter<T> adapter;

  HiveAdapter({required this.typeId, required this.adapter});
}
