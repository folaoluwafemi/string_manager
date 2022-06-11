import 'package:flutter_test/flutter_test.dart';
import 'package:string_manager/string_manager.dart';

import 'src/data/constants/constants.dart';
import 'src/data/mocks/google_translation_mock.dart';
import 'src/data/mocks/hive_mock.dart';

void main() {
  group('setup tests', () {
    late StringManager stringManager;

    setUp(() {
      stringManager = StringManager(
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
  });

  group('stringManager.reg() tests', () {
    late StringManager stringManager;

    setUp(() {
      stringManager = StringManager(
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
    late StringManager stringManager;
    group('setup test', () {
      late StringManager setupStringManger;
      setUp(() async {
        setupStringManger = StringManager(
          language: 'en',
          googleTranslator: GoogleTranslationMock(),
          hive: HiveMock(),
        );
      });

      test(
          'calling .translate() without initializing string manager results in an assertion error',
          () {
        expectLater(
            () => setupStringManger.translate('en'), throwsAssertionError);
      });

      test(
          'calling .translate() on an empty stringManager.stringResource results in an assertion error',
          () {
        //setup
        setupStringManger.initialize();

        expectLater(
          () => setupStringManger.translate('en'),
          throwsAssertionError,
        );
      });
    });
    setUp(() async {
      stringManager = StringManager(
        language: 'en',
        googleTranslator: GoogleTranslationMock(),
        hive: HiveMock(),
      );

      await stringManager.initialize();

      stringManager.reg(iAmABoy);
      stringManager.reg(itIsPlenty);
    });

    test('returns normally', () {
      expectLater(() => stringManager.translate('en'), returnsNormally);
    });

    test(
        'if translation language is the same as initialization language, stringManager.stringResource remains the same',
        () async {
      await stringManager.translate('en');

      List<String> keys = stringManager.stringResource.map.keys.toList();
      List<String> values = stringManager.stringResource.map.values.toList();

      //since dart List is actually a linkedList and dart Map is a LinkedHashMap the order remains the same
      expect(checkListValueEquality(keys, values), equals(true));
    });
    test('translates correctly', () async {
      await stringManager.translate('yo');

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
      late StringManager setupStringManager;
      setUp(() {
        setupStringManager = StringManager(
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
      late StringManager stringManager;
      setUp(() async {
        stringManager = StringManager(
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
      late StringManager stringManager;
      setUp(() async {
        stringManager = StringManager(
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
        'calling the method changes stringManager stringResource if it has been saved before',
        () async {
          stringManager.reg(iAmABoy);
          stringManager.reg(itIsPlenty);

          //save the current values
          await stringManager.save();

          //change the values so as to check against it's change
          await stringManager.translate('yo');

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
}

bool checkListValueEquality(List list1, list2) {
  bool equal = false;
  for (int i = 0; i < list1.length; i++) {
    equal = list1[i] == list2[i];
  }
  return equal;
}
