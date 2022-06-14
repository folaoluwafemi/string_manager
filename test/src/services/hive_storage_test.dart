import 'package:string_manager/src/data/models/string_resource.dart';
import 'package:string_manager/src/services/hive_storage.dart';
import 'package:test/test.dart';

import '../data/constants/constants.dart';
import '../data/mocks/hive_mock.dart';

void main() {
  late HiveStorage hiveStorage;

  setUpAll(() {
    hiveStorage = HiveStorage(hive: HiveMock());
  });

  test('initializing hiveStorage completes normally', () async {
    expectLater(() => hiveStorage.initialize(), returnsNormally);
  });

  test('hiveStorage\'s getStrings method returns an instance of StringResource',
      () {
    expect(hiveStorage.getStrings('en'), isA<StringResource>());
  });

  test('storing a string resource with an map resource returns normally', () {
    expect(
        () => hiveStorage.storeStrings(
              StringResource(resource: resourceMap),
              languageKey: 'en',
            ),
        returnsNormally);
  });
  test('storing a string resource with an empty map resource returns error',
      () {
    expect(
      () => hiveStorage.storeStrings(
        StringResource(),
        languageKey: 'en',
      ),
      throwsAssertionError,
    );
  });
}
