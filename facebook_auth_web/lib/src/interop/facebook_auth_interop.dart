@JS('FB')
library facebook_auth.js;

import 'dart:js_interop';

typedef FbCallback = JSExportedDartFunction;

@JS('init')
external void init(InitOptions options);

@JS('login')
external void login(FbCallback fn, LoginOptions options);

@JS('getLoginStatus')
external void getLoginStatus(FbCallback fn);

@JS('api')
external void api(String request, FbCallback fn);

@JS('logout')
external void logout(FbCallback fn);

@JS()
@anonymous
extension type InitOptions._(JSObject _) implements JSObject {
  external factory InitOptions({
    required String appId,
    required String version,
    required bool cookie,
    required bool xfbml,
  });
  external String get appId;
  external String get version;
  external bool get cookie;
  external bool get xfbml;
}

@JS()
@anonymous
extension type LoginOptions._(JSObject _) implements JSObject {
  external factory LoginOptions({
    required String scope,
    // ignore: non_constant_identifier_names
    required bool return_scopes,
  });
  external String get scope;
  // ignore: non_constant_identifier_names
  external bool get return_scopes;
}
