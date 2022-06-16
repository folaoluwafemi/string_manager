import 'package:test/test.dart';

import 'src/data/constants/constants.dart';
import 'src/data/mocks/google_translation_mock.dart';
import 'src/data/mocks/hive_mock.dart';
import 'src/data/mocks/string_manager_mock.dart';

void main() {
  group('setup tests', () {
    late StringManagerMock stringManager;
    setUp(() {
      stringManager = StringManagerMock(
        language: 'en',
        hive: HiveMock(),
        googleTranslator: GoogleTranslationMock(),
      );
    });
    test(
        'calling any method without initializing stringManager results in an assertionError',
        () {
      expect(() => stringManager.reg('whatever'), throwsAssertionError);
    });
    test('initialization returns normally', () {
      expectLater(() => stringManager.initialize(), returnsNormally);
    });
    test('calling initialize sets stringManger.stringResource if saved before',
        () async {
      await stringManager.initialize();
      stringManager.reg(iAmABoy);
      stringManager.reg(itIsPlenty);

      await stringManager.save();

      await stringManager.close();

      await stringManager.initialize();

      expect(stringManager.stringResource.map.isNotEmpty, equals(true));
    });
    test(
        'calling initialize translates stringManger.stringResource if saved before',
        () async {
      //setup
      HiveMock hiveMock = HiveMock(
        returnDefaults: true,
      );
      GoogleTranslationMock translator = GoogleTranslationMock();
      StringManagerMock strManager = StringManagerMock(
        language: 'en',
        hive: hiveMock,
        googleTranslator: translator,
      );

      await strManager.initialize();

      strManager.reg(iAmABoy);
      strManager.reg(itIsPlenty);

      List<String> initialValues = strManager.stringResource.resources;
      await strManager.save();

      await strManager.close();

      strManager = StringManagerMock(
        language: 'yo',
        googleTranslator: translator,
        hive: hiveMock,
      );

      await strManager.initialize();

      List<String> finalValues = strManager.stringResource.resources;
      expect(
        checkListValueEquality(
          initialValues,
          finalValues,
        ),
        equals(false),
      );
      expect(finalValues.isNotEmpty, equals(true));
      expect(finalValues.contains(iAmABoyTranslation), equals(true));
      expect(finalValues.contains(itIsPlentyTranslation), equals(true));
    });
  });

  group('stringManager.reg() tests', () {
    late StringManagerMock stringManager;

    setUp(() {
      stringManager = StringManagerMock(
        language: 'en',
        hive: HiveMock(),
        googleTranslator: GoogleTranslationMock(),
      );
    });

    test('calling reg() before initialization results in an assertionError',
        () async {
      expect(() => stringManager.reg(iAmABoy), throwsAssertionError);
    });

    test('calling reg() returns normally', () async {
      //setup
      await stringManager.initialize();

      expect(() => stringManager.reg(iAmABoy), returnsNormally);
    });

    test('calling reg() returns a string', () async {
      //setup
      await stringManager.initialize();

      var result = stringManager.reg(iAmABoy);
      expect(result, isA<String>());
    });

    test(
        'calling reg() adds the entered string into stringManager.stringResource',
        () async {
      //setup
      await stringManager.initialize();

      stringManager.reg(iAmABoy);

      expect(
        stringManager.stringResource.map.containsKey(iAmABoy),
        equals(true),
      );
      expect(
        stringManager.stringResource.map.containsValue(iAmABoy),
        equals(true),
      );
    });
  });

  group('stringManager.translate() tests', () {
    late StringManagerMock stringManager;
    group('setup test', () {
      late StringManagerMock setupStringManger;
      setUp(() async {
        setupStringManger = StringManagerMock(
          language: 'en',
          googleTranslator: GoogleTranslationMock(),
          hive: HiveMock(),
        );
      });

      test(
          'calling .translate() without initializing string manager results in an assertion error',
          () {
        expectLater(
            () => setupStringManger.translate(to: 'en'), throwsAssertionError);
      });

      test(
          'calling .translate() on an empty stringManager.stringResource results in an assertion error',
          () {
        //setup
        setupStringManger.initialize();

        expectLater(
          () => setupStringManger.translate(to: 'en'),
          throwsAssertionError,
        );
      });
    });
    setUp(() async {
      stringManager = StringManagerMock(
        language: 'en',
        googleTranslator: GoogleTranslationMock(),
        hive: HiveMock(),
      );

      await stringManager.initialize();

      stringManager.reg(iAmABoy);
      stringManager.reg(itIsPlenty);
    });

    test('returns normally', () {
      expectLater(() => stringManager.translate(to: 'en'), returnsNormally);
    });

    test(
        'if translation language is the same as initialization language, stringManager.stringResource remains the same',
        () async {
      await stringManager.translate(to: 'en');

      List<String> keys = stringManager.stringResource.map.keys.toList();
      List<String> values = stringManager.stringResource.map.values.toList();

      //since dart List is actually a linkedList and dart Map is a LinkedHashMap the order remains the same
      expect(checkListValueEquality(keys, values), equals(true));
    });
    test('translates correctly', () async {
      await stringManager.translate(to: 'yo');

      expect(
        stringManager.stringResource.map[iAmABoy],
        equals(iAmABoyTranslation),
      );
      expect(
        stringManager.stringResource.map[itIsPlenty],
        equals(itIsPlentyTranslation),
      );
    });
  });

  group('storage tests', () {
    group('setup tests', () {
      late StringManagerMock setupStringManager;
      setUp(() {
        setupStringManager = StringManagerMock(
          language: 'en',
          googleTranslator: GoogleTranslationMock(),
          hive: HiveMock(),
        );
      });

      test(
          'calling save() without initializing stringManager results in an assertionError',
          () {
        expect(setupStringManager.save, throwsAssertionError);
      });
      test(
          'calling getStrings() without initializing stringManager results in an assertionError',
          () {
        expect(setupStringManager.getStrings, throwsAssertionError);
      });
    });
    group('stringManager.save() tests', () {
      late StringManagerMock stringManager;
      setUp(() async {
        stringManager = StringManagerMock(
          language: 'en',
          googleTranslator: GoogleTranslationMock(),
          hive: HiveMock(),
        );

        await stringManager.initialize();

        stringManager.reg(iAmABoy);
        stringManager.reg(itIsPlenty);
      });

      test('returns normally', () {
        expectLater(stringManager.save, returnsNormally);
      });

      test('returns normally', () {
        expectLater(stringManager.save, returnsNormally);
      });
    });
    group('stringManager.getStrings() tests', () {
      late StringManagerMock stringManager;
      setUp(() async {
        stringManager = StringManagerMock(
          language: 'en',
          googleTranslator: GoogleTranslationMock(),
          hive: HiveMock(),
        );

        await stringManager.initialize();
      });

      test('returns normally', () {
        expect(stringManager.getStrings, returnsNormally);
      });

      test(
          'if stringManager string resources are empty and nothing has been saved calling getStrings does nothing',
          () {
        stringManager.getStrings();
        expect(stringManager.stringResource.map.isEmpty, equals(true));
      });

      test(
        'calling the method does not delete the stringManager stringResource if it has been saved before',
        () async {
          stringManager.reg(iAmABoy);
          stringManager.reg(itIsPlenty);

          //save the current values
          await stringManager.save();

          //change the values so as to check against it's change
          await stringManager.translate(to: 'yo');

          List<String> currentValues =
              stringManager.stringResource.map.values.toList();

          stringManager.getStrings(language: 'en');

          List<String> newValues =
              stringManager.stringResource.map.values.toList();

          expect(stringManager.stringResource.map.isNotEmpty, equals(true));
        },
      );
      test(
        'calling the method changes stringManager stringResource if it has been saved before',
        () async {
          stringManager.reg(iAmABoy);
          stringManager.reg(itIsPlenty);

          //save the current values
          await stringManager.save();

          //change the values so as to check against it's change
          await stringManager.translate(to: 'yo');

          List<String> currentValues =
              stringManager.stringResource.map.values.toList();

          stringManager.getStrings(language: 'en');

          List<String> newValues =
              stringManager.stringResource.map.values.toList();

          expect(
              checkListValueEquality(currentValues, newValues), equals(false));
        },
      );
    });
  });

  group('close() test', () {
    test('setup test -- calling ', () {
      late StringManagerMock setupStringManager;
      setupStringManager = StringManagerMock(
        language: 'en',
        googleTranslator: GoogleTranslationMock(),
        hive: HiveMock(),
      );
      expect(setupStringManager.close, throwsAssertionError);
    });
    late StringManagerMock stringManger;
    setUp(() async {
      stringManger = StringManagerMock(
        language: 'en',
        googleTranslator: GoogleTranslationMock(),
        hive: HiveMock(),
      );
      await stringManger.initialize();
    });

    test('calling close returns normally', () {
      expectLater(stringManger.close, returnsNormally);
    });

    test(
        'calling another method after close is called results in an assertionError',
        () async {
      await stringManger.close();

      expect(() => stringManger.reg('new string'), throwsAssertionError);
    });
  });
}

bool checkListValueEquality(List list1, list2) {
  bool equal = false;
  for (int i = 0; i < list1.length; i++) {
    equal = list1[i] == list2[i];
  }
  return equal;
}
