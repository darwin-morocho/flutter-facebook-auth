![image](https://user-images.githubusercontent.com/15864336/101827170-f5ce3180-3afd-11eb-9a60-5933a15f337b.png)

<p align="center">
  <a href="https://pub.dev/packages/flutter_facebook_auth"><img alt="pub version" src="https://img.shields.io/pub/v/flutter_facebook_auth?color=%2300b0ff&label=flutter_facebook_auth&style=flat-square"></a>
  <a href="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth">
  <img src="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth/branch/master/graph/badge.svg?token=XEXUNVP0UK"/>
  </a>
  <img alt="last commit" src="https://img.shields.io/github/last-commit/the-meedu-app/flutter-facebook-auth?color=%23ffa000&style=flat-square"/>
  <img alt="license" src="https://img.shields.io/github/license/the-meedu-app/flutter-facebook-auth?style=flat-square"/>
  <img alt="stars" src="https://img.shields.io/github/stars/the-meedu-app/flutter-facebook-auth?style=social"/>
</p>

## Features

- Login on Android, iOS, Web and macOS.
- Express login on Android.
- Granted and declined permissions.
- User information, picture profile and more.
- Provide an access token to make request to the Graph API.

Full documentation 👉 https://facebook.meedu.app

✅ Don't forget to leave your like if this plugin was useful for you.

> **IMPORTANT**: When you install this plugin you need to configure the plugin on Android before run the project again . If you don't do it you will have a **No implementation found** error because the facebook SDK on Android throws an Exception when the configuration is not defined yet and this locks the other plugins in your project. If you don't need the plugin yet please remove or comment it.

---

## macOS support

in your `macos/runner/info.plist` folder you must add

```xml
<key>com.apple.security.network.server</key>
<true/>
```

Now in `xcode` select the `Runner` target and go to **Signing & Capabilities** and enable
`Outgoing Connections`

<img width="496" alt="Captura de Pantalla 2022-05-08 a la(s) 17 17 23" src="https://user-images.githubusercontent.com/15864336/167318086-b3812f19-0834-4291-acc8-694b890dfe7e.png">

Unlinke ios, android and web for desktop app the facebook session data is not stored by default. In that case this plugin uses `flutter_secure_storage` to
secure store the session data.

To use `flutter_secure_storage` on macOS you need to add the `Keychain Sharing` capability

<img width="574" alt="image" src="https://user-images.githubusercontent.com/15864336/167318216-4bdd7e07-3105-444a-8a23-dfbe24b6c511.png">

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
      appId: "1329834907365798",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(MyApp());
}
```
