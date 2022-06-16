class Constants {
  static const String stringStorageKey = 'StringManager';
  static const String languageStorageKey = 'languageKey';
  static const String languageStorageId = 'languageKey';
  static const int stringTypeId = 200;
}


bool checkListValueEquality(List list1, list2) {
  bool equal = false;
  for (int i = 0; i < list1.length; i++) {
    equal = list1[i] == list2[i];
  }
  return equal;
}
