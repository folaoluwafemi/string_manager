import 'package:hive/hive.dart';
import 'package:string_manager/src/data/adapters/hive_adapter.dart';
import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/string_manager.dart';

class HiveStorage {
  late final Box<StringResource> storageBox;
  final HiveAdapter _hive;

  HiveStorage({required HiveAdapter hive}) : _hive = hive;

  Future<void> initialize() async {
    _hive.init('string_path');
    _hive.registerAdapter(StringResourceAdapter());
    storageBox = await _hive.openBox<StringResource>(StringManager.storageKey);
  }

  StringResource? getStrings(String languageKey) {
    StringResource? stringResource = storageBox.get(languageKey);
    return stringResource;
  }

  storeStrings(StringResource resource, {required String languageKey}) {
    storageBox.put(languageKey, resource);
  }
}
