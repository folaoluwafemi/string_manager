import 'dart:developer' as dev;

import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:translator/translator.dart';

class GoogleTranslationService {
  final GoogleTranslator translator =
      GoogleTranslator(client: ClientType.siteGT);

  Future<String> translateString(
    String text, {
    required String from,
    required String to,
  }) async {
    try {
      return await _translate(text, from: from, to: to);
    } catch (e) {
      dev.log('unable to translate $text', stackTrace: StackTrace.current);
      dev.log('$e');
      return text;
    }
  }

  _translate(String text, {required String from, required String to}) async {
    Translation translation =
        await translator.translate(text, from: from, to: to);
    return translation.text;
  }

  Future<StringResource> translateStringResource(
    StringResource resource, {
    required String from,
    required String to,
  }) async {
    try {
      return await _translateResource(resource, from: from, to: to);
    } catch (e) {
      dev.log('$e');
      throw Exception(e);
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
