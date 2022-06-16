```dart
import 'package:string_manager/string_manager.dart';

void main() async {
  StringManager stringManager = StringManager(language: 'en');

  ///you must initialize stringManager first
  await stringManager.initialize();

  ///register your project strings synchronously
  stringManager.reg('hello world');

  ///translate your strings to any language (Yoruba in this case) using google translate
  await stringManager.translate(to: 'yo');

  ///saves your strings using hive
  await stringManager.save();

  print(stringManager.stringResource.resources); //output: ["Mo ki O Ile Aiye"]

  await stringManager.close();
}
```