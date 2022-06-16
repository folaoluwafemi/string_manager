import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:string_manager/src/data/constants/constants.dart';
import 'package:string_manager/src/data/models/string_resource.dart';

import '../constants/constants.dart';

class MockBox<E> extends Mock implements Box<E> {
  final bool returnDefaults;

  MockBox(this.returnDefaults) {
    if (returnDefaults) {
      language = 'en';
      resource = StringResource(resource: {
        iAmABoy: iAmABoy,
        itIsPlenty: itIsPlenty,
      });
    }
  }

  StringResource resource = StringResource();
  String? language;

  bool open = false;

  @override
  bool get isOpen => open;

  @override
  E? get(key, {E? defaultValue}) {
    if (key == Constants.languageStorageKey) {
      return language as E?;
    } else {
      return resource as E;
    }
  }

  @override
  Future<void> put(key, E value) async {
    if (value is String) {
      language = value;
      return;
    }
    resource = value as StringResource;
  }

  @override
  Future<void> close() async {
    open = false;
    dev.log('close called');
  }
}

class HiveMock extends Mock implements HiveInterface {
  final bool _returnDefaults;

  HiveMock({bool? returnDefaults}) : _returnDefaults = returnDefaults ?? false;

  @override
  void init(
    String? path, {
    HiveStorageBackendPreference backendPreference =
        HiveStorageBackendPreference.native,
  }) {
    dev.log('init called');
  }

  @override
  bool isAdapterRegistered(int typeId) {
    return true;
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
    MockBox<E> mockBox = MockBox<E>(
      _returnDefaults,
    );
    mockBox.open = true;
    return Future.value(mockBox);
  }
}
