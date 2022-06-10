library string_manager;

import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/storage_service/hive_storage.dart';
import 'package:string_manager/src/services/string_translation_service/google_translation_service.dart';

abstract class _StringManager {
  final String language;
  StringResource _stringResource;
  final HiveStorage _storage;
  final GoogleTranslationService _translator;
  bool _initialized = false;

  _StringManager({required this.language})
      : _stringResource = StringResource(),
        _storage = HiveStorage(),
        _translator = GoogleTranslationService();

  Future<void> initialize() async {
    await _storage.initialize();
    _initialized = true;
  }

  StringResource get stringResource => _stringResource;

  String register(String text) {
    _stringResource.add(text);
    return text;
  }

  void save() {
    _storage.storeStrings(_stringResource, languageKey: language);
  }

  void getStrings() {
    StringResource? resource = _storage.getStrings(language);
    if (resource == null) {
      return;
    }
    _stringResource = StringResource(resource: resource.map);
  }

  Future<void> translate(String to) async {
    StringResource resource = await _translator.translateStringResource(
      _stringResource,
      from: language,
      to: to,
    );

    _stringResource = resource;
  }
}

class StringManager extends _StringManager {
  static const int storageTypeId = 2862004;
  static const String storageKey = 'StringManager';

  StringManager({required super.language});
}
