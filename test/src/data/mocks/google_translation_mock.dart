import 'package:mockito/mockito.dart';
import 'package:translator/translator.dart';

import '../constants/constants.dart';

class TranslationMock extends Mock implements Translation {
  @override
  final String text;
  final String source;

  TranslationMock(
    this.source,
    this.text,
  );
}

class GoogleTranslationMock extends Mock implements GoogleTranslator {
  @override
  Future<Translation> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) {
    String? text = translationMap[sourceText];

    if (text == null) {
      return throw Exception('invalid text');
    }


    return Future.value(TranslationMock(
      sourceText,
      text,
    ));
  }
}
