@JS('FB')
library facebook_auth.js;

import 'package:js/js.dart';
import 'package:meta/meta.dart' show required;

typedef FbCallback = void Function(dynamic response);

@JS('init')
external init(InitOptions options);

@JS('login')
external login(FbCallback fn, LoginOptions options);

@JS('getLoginStatus')
external getLoginStatus(FbCallback fn);

@JS('api')
external api(String request, FbCallback fn);

@JS('logout')
external logout(FbCallback fn);

@JS()
@anonymous
class InitOptions {
  external factory InitOptions({
    @required String appId,
    @required String version,
    @required bool cookie,
    @required bool xfbml,
  });
  external String get appId;
  external String get version;
  external bool get cookie;
  external bool get xfbml;
}

@JS()
@anonymous
class LoginOptions {
  external factory LoginOptions({
    @required String scope,
    // ignore: non_constant_identifier_names
    @required bool return_scopes,
  });
  external String get scope;
  // ignore: non_constant_identifier_names
  external bool get return_scopes;
}
