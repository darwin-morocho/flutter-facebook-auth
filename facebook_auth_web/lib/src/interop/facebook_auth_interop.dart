@JS()
library facebook_auth.js;

import 'package:js/js.dart';

@JS('FB')
class FB implements FbInterface {
  external factory FB();
  external getAccessToken();
  external getUserData(String fields);
  external login(String scope);
  external logOut();
}

@JS()
class Promise<T> {
  external Promise(
    void Function(void Function(T result) resolve, Function reject) executor,
  );

  external Promise then(
    void Function(T result) onFulfilled, [
    Function? onRejected,
  ]);
}

abstract class FbInterface {
  getAccessToken();
  getUserData(String fields);
  login(String scope);
  logOut();
}
