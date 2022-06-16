import 'package:hive/hive.dart';
import 'package:string_manager/src/data/constants/constants.dart';
import 'package:string_manager/src/data/models/string_resource.dart';

class HiveStorage {
  Box<StringResource>? _storageBox;
  Box<String>? _languageBox;
  final HiveInterface _hive;

  HiveStorage({required HiveInterface hive}) : _hive = hive;

  Future<void> initialize() async {
    _hive.init('string_path');
    if (!_hive.isAdapterRegistered(Constants.stringTypeId)) {
      _hive.registerAdapter<StringResource>(StringResourceAdapter());
    }
    _storageBox ??=
        await _hive.openBox<StringResource>(Constants.stringStorageKey);
    _languageBox ??= await _hive.openBox<String>(Constants.languageStorageKey);
  }

  StringResource? getStrings(String languageKey) {
    StringResource? stringResource = _storageBox?.get(languageKey);
    return stringResource;
  }

  Future<void> close() async {
    await _storageBox?.close();
    await _languageBox?.close();
    await _hive.close();
  }

  String? getStorageLanguage() {
    return _languageBox?.get(Constants.languageStorageId);
  }

  Future<void> setStorageLanguage(String language) async {
    await _languageBox?.put(Constants.languageStorageId, language);
  }

  Future<void> storeStrings(StringResource resource,
      {required String languageKey}) async {
    assert(
        resource.map.isNotEmpty, 'string resource must not have an empty map');
    await _storageBox?.put(languageKey, resource);
  }
}
