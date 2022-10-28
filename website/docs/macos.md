
# macOS support

in your `macos/runner/info.plist` folder you must add

```xml
<key>com.apple.security.network.server</key>
<true/>
```

Now in `xcode` select the `Runner` target and go to **Signing & Capabilities** and enable
`Outgoing Connections`

<img width="496" alt="Captura de Pantalla 2022-05-08 a la(s) 17 17 23" src="https://user-images.githubusercontent.com/15864336/167318086-b3812f19-0834-4291-acc8-694b890dfe7e.png"/>

Unlinke ios, android and web for desktop app the facebook session data is not stored by default. In that case this plugin uses `flutter_secure_storage` to
secure store the session data.

To use `flutter_secure_storage` on macOS you need to add the `Keychain Sharing` capability

<img width="574" alt="image" src="https://user-images.githubusercontent.com/15864336/167318216-4bdd7e07-3105-444a-8a23-dfbe24b6c511.png"/>

Finally in your `main.dart` you need to initialize this plugin to be available for macOS

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

void main() async {
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "1329834907365798",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(MyApp());
}
```

If your app also support web you must use the next code instead of above code

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

void main() async {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v14.0",
    );
  }
  runApp(MyApp());
}
```
