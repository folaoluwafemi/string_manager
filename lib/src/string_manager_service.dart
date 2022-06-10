import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/storage_service/hive_storage.dart';

class StringManager {
  final String language;
  StringResource _stringResource;
  final HiveStorage _storage;
  bool _initialized = false;

  StringManager({required this.language})
      : _stringResource = StringResource(),
        _storage = HiveStorage();

  Future<void> initialize() async {
    await _storage.initialize();
    _initialized = true;
  }

  static const int storageTypeId = 2862004;
  static const String storageKey = 'StringManager';

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

  void translate(){}

}
