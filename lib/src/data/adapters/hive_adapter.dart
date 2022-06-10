import 'package:hive/hive.dart';

abstract class StorageInterface {}

class HiveAdapter extends StorageInterface {
  final HiveInterface hiveObject;

  HiveAdapter() : hiveObject = Hive;

  Future<Box<E>> openBox<E>(String name) {
    return hiveObject.openBox<E>(name);
  }

  void init(
    String? path, {
    HiveStorageBackendPreference backendPreference =
        HiveStorageBackendPreference.native,
  }) =>
      hiveObject.init(
        path,
        backendPreference: backendPreference,
      );

  void registerAdapter<T>(
    TypeAdapter<T> adapter, {
    bool internal = false,
    bool override = false,
  }) =>
      hiveObject.registerAdapter(
        adapter,
        internal: internal,
        override: override,
      );
}
