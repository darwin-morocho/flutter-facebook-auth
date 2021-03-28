@JS()
library stringify;

import 'package:js/js.dart';
import 'dart:convert';

// Calls invoke JavaScript `JSON.stringify(obj)`.
@JS('JSON.stringify')
external String stringify(Object obj);

convert(dynamic object) {
  return jsonDecode(stringify(object));
}
