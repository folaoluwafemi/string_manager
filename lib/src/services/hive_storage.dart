import 'package:hive/hive.dart';
import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/string_manager.dart';

class HiveStorage {
  late final Box<StringResource> storageBox;
  final HiveInterface _hive;

  HiveStorage({required HiveInterface hive}) : _hive = hive;

  Future<void> initialize() async {
    _hive.init('string_path');
    _hive.registerAdapter(StringResourceAdapter());
    storageBox = await _hive.openBox<StringResource>(StringManager.storageKey);
  }

  StringResource? getStrings(String languageKey) {
    StringResource? stringResource = storageBox.get(languageKey);
    return stringResource;
  }

  Future<void> storeStrings(StringResource resource,
      {required String languageKey}) async {
    assert(
        resource.map.isNotEmpty, 'string resource must not have an empty map');
    await storageBox.put(languageKey, resource);
  }
}
