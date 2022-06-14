import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/translation_service.dart';
import 'package:test/test.dart';

import '../data/constants/constants.dart';
import '../data/mocks/google_translation_mock.dart';

void main() {
  late TranslationService translationService;

  setUpAll(() {
    translationService =
        TranslationService(translator: GoogleTranslationMock());
  });

  group('translationService.translateString() tests', () {
    test('calling translate on a string returns normally', () async {
      var translation = await translationService.translateString(iAmABoy,
          from: 'en', to: 'yo');

      expect(translation, isA<String>());
    });

    test(
        'calling translate on "I am a boy" return "Okun rin ni mi" as expected',
        () async {
      var translation = await translationService.translateString(
        iAmABoy,
        from: 'en',
        to: 'yo',
      );

      expect(translation, equals(iAmABoyTranslation));
    });

    test(
        'calling translate on a text with equal languages returns the same text',
        () async {
      String translation = await translationService.translateString(
        iAmABoy,
        from: 'en',
        to: 'en',
      );

      expect(translation, equals(iAmABoy));
    });
  });

  group('translationService.translateStringResource() test', () {
    test('returns normally', () async {
      var result = await translationService.translateStringResource(
        StringResource(
          resource: resourceMap,
        ),
        from: 'en',
        to: 'yo',
      );
      expect(() => result, returnsNormally);
    });
    test('returns a string resource', () async {
      var result = await translationService.translateStringResource(
        StringResource(
          resource: resourceMap,
        ),
        from: 'en',
        to: 'yo',
      );
      expect(result, isA<StringResource>());
    });

    test('translates the string correctly', () async {
      StringResource result = await translationService.translateStringResource(
        StringResource(
          resource: resourceMap,
        ),
        from: 'en',
        to: 'yo',
      );

      expect(result.map.containsValue(iAmABoyTranslation), equals(true));
    });

    test('calling the method with the same language returns the same text',
        () async {
      StringResource result = await translationService.translateStringResource(
        StringResource(
          resource: resourceMap,
        ),
        from: 'en',
        to: 'en',
      );

      expect(result.map.containsValue(iAmABoyTranslation), equals(false));
      expect(result.map.containsValue(iAmABoy), equals(true));
    });

    test(
        'calling the method with a resource with an empty map fails with an assertionError',
        () async {
      expect(
        () => translationService.translateStringResource(
          StringResource(),
          from: 'en',
          to: 'en',
        ),
        throwsAssertionError,
      );
    });
  });
}
