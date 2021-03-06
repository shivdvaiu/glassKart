import 'dart:convert' as convert;

class JsonUtils {
  const JsonUtils._internal();

  static String? toJson(Object? data) {
    try {
      if (data == null) {
        return null;
      }
      return convert.json.encode(data);
    } on Exception catch (e) {
    
      return null;
    }
  }

  static dynamic fromJson(String? json) {
    try {
      if (json?.isEmpty ?? false) {
        return null;
      }
      return convert.json.decode(json!);
    } on Exception catch (e) {
   
      return null;
    }
  }
}
