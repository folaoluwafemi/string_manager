<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

a pure dart package for managing app strings in dart particularly internationalization

## Features

- keep your project strings DRY
- Translate all your project strings easily on the fly with one method call

### Getting started

add this to your pubspec.yaml file

 ```yaml
dependencies:
  string_manager:
```

## Usage

```dart
import 'package:string_manager/string_manager.dart';


void main() async {
  StringManager stringManager = StringManger(
    language: 'en', //your default language
  );
  await stringManager.initialize(); //you must initialize stringManager first

  stringManager.reg('hello world'); //register your project strings
  
  await stringManager.translate('yo'); //translate your strings to any language (Yoruba in this case) using google translate
  
  print(stringManger.resources); //output: ["Mo ki O Ile Aiye"]
}
```
note that the `stringManger.reg('yourString')` method returns your registered string, ie:
```dart
    //...
    print(stringManger.reg('hello world')); //output: hello world
    //...
```

## Additional information

If you face any errors kindly create an issue, and if you wish to add a feature I will be more than
happy to merge your PR

# Enjoy your internationalization redefined. 😃