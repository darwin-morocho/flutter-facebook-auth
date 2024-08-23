@JS()
library stringify;

import 'dart:convert';
import 'dart:js_interop';

// Calls invoke JavaScript `JSON.stringify(obj)`.
@JS('JSON.stringify')
external String stringify(JSObject obj);

/// convert the a javascript object to a valid map
Map<String, dynamic> convert(dynamic object) {
  return jsonDecode(stringify(object));
}
