@JS()
library mock_facebook_auth;

import 'package:js/js.dart';

@JS()
@anonymous
class FbMock {
  external factory FbMock();
}

// Wire to the global 'window.FB' object.
@JS('FB')
external set fbMock(FbMock mock);

@JS('FB')
external FbMock get fbMock;
