import 'package:hive/hive.dart';
import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/hive_storage.dart';
import 'package:string_manager/src/services/translation_service.dart';
import 'package:translator/translator.dart';

abstract class _StringManager {
  String _language;
  StringResource _stringResource;
  final HiveStorage _storage;
  final TranslationService _translator;
  bool _initialized = false;

  _StringManager({
    required String language,
    HiveInterface? hive,
    GoogleTranslator? googleTranslator,
  })  : _stringResource = StringResource(),
        _language = language,
        _storage = HiveStorage(hive: hive ?? Hive),
        _translator = TranslationService(
          translator: googleTranslator ?? GoogleTranslator(),
        );

  Future<void> initialize() async {
    await _storage.initialize();
    _initialized = true;
    getStrings();
  }

  String get language {
    assert(_initialized, 'stringManager must be initialized');
    return _language;
  }

  StringResource get stringResource {
    assert(_initialized, 'stringManager must be initialized');

    return _stringResource;
  }

  String reg(String text) {
    assert(_initialized, 'stringManager must be initialized');
    return _stringResource.register(text);
  }

  Future<void> save() async {
    assert(_initialized, 'stringManager must be initialized');

    await _storage.storeStrings(_stringResource, languageKey: _language);
  }

  void getStrings({String? language}) {
    language ??= _language;
    assert(_initialized, 'stringManager must be initialized');

    StringResource? resource = _storage.getStrings(language);
    if (resource == null) {
      return;
    }
    _stringResource = StringResource(resource: resource.map);
  }

  Future<void> close() async {
    assert(_initialized, 'stringManager must be initialized');
    await _storage.close();
    _initialized = false;
  }

  Future<void> translate(String to) async {
    assert(_initialized, 'stringManager must be initialized');
    try {
      StringResource resource = await _translator.translateStringResource(
        _stringResource,
        from: _language.trim(),
        to: to.trim(),
      );
      if (!checkListValueEquality(
          _stringResource.resources, resource.resources)) {
        _stringResource = resource;
        _language = to;
      }
    } catch (e) {
      rethrow;
    }
  }
}


bool checkListValueEquality(List list1, list2) {
  bool equal = false;
  for (int i = 0; i < list1.length; i++) {
    equal = list1[i] == list2[i];
  }
  return equal;
}


class StringManagerTest extends _StringManager {
  static const int storageTypeId = 200;
  static const String storageKey = 'StringManager';

  StringManagerTest({
    required super.language,
    super.hive,
    super.googleTranslator,
  });
}


class StringManager extends _StringManager {
  static const int storageTypeId = 200;
  static const String storageKey = 'StringManager';

  StringManager._({
  required super.language,
});

static StringManager? _instance;

factory StringManager({required String language}) {
  _instance ??= StringManager._(language: language);
  return _instance!;
}

static StringManager get instance {
  assert(_instance != null, 'Constructor wasn\'t called');
  return _instance!;
}
}
