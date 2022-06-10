import 'package:string_manager/src/data/models/string_resource.dart';

abstract class StringTranslationInterface {

  translateString(String text, {required String from, required String to});

  translateStringResource(StringResource resource, {required String from, required String to});


}