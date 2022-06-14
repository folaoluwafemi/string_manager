import 'package:test/test.dart';
import 'package:string_manager/src/data/models/string_resource.dart';

import '../constants/constants.dart';

void main() {
  group('string resource model optional constructor test', () {
    late StringResource stringResource;
    setUp(() {
      stringResource = StringResource(
        resource: translationMap,
      );
    });

    test('returns normally', () {
      expect(
          () => StringResource(
                resource: translationMap,
              ),
          returnsNormally);
    });

    test(
        'string map passed into the constructor is exactly the same as stringResource.map',
        () {
      expect(stringResource.map, equals(translationMap));
    });
  });

  group('string resource model tests for .register()', () {
    late StringResource stringResource;
    setUp(() {
      stringResource = StringResource();
    });

    test('returns normally', () {
      expect(() => stringResource.register('word'), returnsNormally);
    });
    test(
        'registering a text updates the stringResource.map to hold that text if it did not have it before',
        () {
      expect(stringResource.map.containsKey(iAmABoy), equals(false));
      expect(stringResource.map.containsValue(iAmABoy), equals(false));

      //act
      stringResource.register(iAmABoy);

      expect(stringResource.map.containsKey(iAmABoy), equals(true));
      expect(stringResource.map.containsValue(iAmABoy), equals(true));
    });
    test('registering a text returns a string', () {
      //act
      var result = stringResource.register(iAmABoy);

      expect(result, isA<String>());
    });
    test('registering a text returns a string equal to the input', () {
      //act
      var result = stringResource.register(iAmABoy);

      expect(result, equals(iAmABoy));
    });
  });
}
