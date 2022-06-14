import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:string_manager/src/data/models/string_resource.dart';

class MockBox<E> extends Mock implements Box<E> {
  StringResource resource = StringResource();

  @override
  E? get(key, {E? defaultValue}) {
    return resource as E;
  }

  @override
  Future<void> put(key, E value) async {
    resource = value as StringResource;
  }
}

class HiveMock extends Mock implements HiveInterface {
  @override
  void init(
    String? path, {
    HiveStorageBackendPreference backendPreference =
        HiveStorageBackendPreference.native,
  }) {
    dev.log('init called');
  }

  @override
  void registerAdapter<T>(TypeAdapter<T> adapter,
      {bool internal = false, bool override = false}) {
    dev.log('adapter ${T.runtimeType} registered');
  }

  @override
  Future<void> close() async {
    dev.log('close called');
  }

  @override
  bool isAdapterRegistered(int typeId) {
    return true;
   }

  @override
  Future<Box<E>> openBox<E>(
    String name, {
    HiveCipher? encryptionCipher,
    KeyComparator? keyComparator,
    CompactionStrategy? compactionStrategy,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    String? collection,
    @Deprecated('Use encryptionCipher instead') List<int>? encryptionKey,
  }) {
    return Future.value(MockBox<E>());
  }
}
