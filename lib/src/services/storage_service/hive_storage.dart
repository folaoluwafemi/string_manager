import 'package:hive/hive.dart';
import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/string_manager_service.dart';

class HiveStorage {
  late final Box<StringResource> storageBox;

  Future<void> initialize() async {
    Hive.registerAdapter(StringResourceAdapter());
    storageBox = await Hive.openBox<StringResource>(StringManager.storageKey);
  }

  StringResource? getStrings(String languageKey) {
    StringResource? stringResource = storageBox.get(languageKey);
    return stringResource;
  }

  storeStrings(StringResource resource, {required String languageKey}) {
    storageBox.put(languageKey, resource);
  }
}
