import 'dart:developer' as dev;

import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator;

  TranslationService({required GoogleTranslator translator})
      : _translator = translator;

  Future<String> translateString(
    String text, {
    required String from,
    required String to,
  }) async {
    try {
      if (from == to) {
        return text;
      }
      return await _translate(text, from: from, to: to);
    } catch (e) {
      dev.log('unable to translate $text', stackTrace: StackTrace.current);
      dev.log('$e');
      return text;
    }
  }

  _translate(String text, {required String from, required String to}) async {
    Translation translation =
        await _translator.translate(text, from: from, to: to);
    return translation.text;
  }

  Future<StringResource> translateStringResource(
    StringResource resource, {
    required String from,
    required String to,
  }) async {
    try {
      assert(resource.map.isNotEmpty, 'map must not be empty');
      return await _translateResource(resource, from: from, to: to);
    } catch (e) {
      dev.log('$e');
      rethrow;
    }
  }

  Future<StringResource> _translateResource(
    StringResource stringResource, {
    required String from,
    required String to,
  }) async {
    Map<String, String> newResource = {};
    for (MapEntry source in stringResource.map.entries) {
      String translatedString =
          await translateString(source.value, from: from, to: to);
      newResource[source.key] = translatedString;
    }
    StringResource newStringResource = StringResource(resource: newResource);
    return newStringResource;
  }
}
