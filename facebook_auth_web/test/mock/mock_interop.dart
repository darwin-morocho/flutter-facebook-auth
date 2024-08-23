@JS()
library mock_facebook_auth;

import 'dart:js_interop';

@JS()
@anonymous
extension type FbMock._(JSObject _) implements JSObject {
  external factory FbMock();
}

// Wire to the global 'window.FB' object.
@JS('FB')
external set fbMock(FbMock mock);

@JS('FB')
external FbMock get fbMock;
