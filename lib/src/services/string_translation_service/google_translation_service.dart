import 'dart:developer' as dev;

import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/string_translation_service/string_translation_interface.dart';
import 'package:translator/translator.dart';

class GoogleTranslationService implements StringTranslationInterface {
  final GoogleTranslator translator =
      GoogleTranslator(client: ClientType.siteGT);

  @override
  translateString(
    String text, {
    required String from,
    required String to,
  }) async {
    try {
      await _translate(text, from: from, to: to);
    } catch (e) {
      dev.log('$e');
    }
  }

  _translate(String text, {required String from, required String to}) async {
    Translation translation =
        await translator.translate(text, from: from, to: to);
    return translation.text;
  }

  @override
  Future<List<String>> translateStringResource(
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

  Future<List<String>> _translateResource(
    StringResource stringResource, {
    required String from,
    required String to,
  }) async {
    List<String> translatedStrings = [];
    for (String sourceText in stringResource.resources) {
      String translatedString = await _translate(sourceText, from: from, to: to);
      translatedStrings.add(translatedString);
    }
    return translatedStrings;
  }
}
