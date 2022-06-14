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
    StringResource resource = await _translator.translateStringResource(
      _stringResource,
      from: _language,
      to: to,
    );

    _language = to;

    _stringResource = resource;
  }
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

  StringManager({
    required super.language,
  });
}
