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

The easiest way to integrate Facebook Login in your Flutter app across **Android, iOS, Web, macOS and Windows**.

---

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Platform Configuration](#platform-configuration)
  - [Android](#android-configuration)
  - [iOS](#ios-configuration)
  - [Web](#web-configuration)
  - [macOS](#macos-configuration)
  - [Windows](#windows-configuration)
- [Usage](#usage)
  - [Initialize (Web, macOS & Windows)](#initialize-web-macos-and-windows)
  - [Login Request](#login-request)
  - [App Tracking Transparency & Limited Login (iOS)](#app-tracking-transparency--limited-login-ios)
  - [Check if User is Logged](#check-if-user-is-logged)
  - [Get User Profile / Data](#get-user-profile--data)
  - [Express Login (Android)](#express-login-android)
  - [Log Out](#log-out)
  - [Using with Firebase Auth](#using-with-firebase-auth)

---

## Features

- Login on Android, iOS, Web, macOS and Windows.
- Express login on Android.
- Granted and declined permissions handling.
- Read user information, profile pictures, and customized Graph API fields.
- Access token retrieval to make requests to the Facebook Graph API.
- Support for iOS AppTrackingTransparency and Limited Login mode.

---

## Installation

Add `flutter_facebook_auth` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_facebook_auth: ^7.3.1
```

---

## Platform Configuration

### Android Configuration

> **IMPORTANT**: You must configure the plugin on Android before running the app. If you don't, the Facebook SDK will throw an exception during initialization that will cause a **MissingPluginException / No implementation found** error locking other plugins.

1. **`minSdkVersion` Requirement**:
   Requires `minSdkVersion 21` or higher in `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       minSdkVersion 21
   }
   ```

2. **Resources (`strings.xml`)**:
   Open or create `/android/app/src/main/res/values/strings.xml` and add your App ID and Client Token:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
       <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
   </resources>
   ```
   *(Find the **Client Token** in Meta Developers Console > Your App > Settings > Advanced > Client Token).*

3. **Manifest (`AndroidManifest.xml`)**:
   In `/android/app/src/main/AndroidManifest.xml`, add the internet permission before `<application>`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
   Inside `<application>`, add the metadata tags:
   ```xml
   <application ...>
       <meta-data
           android:name="com.facebook.sdk.ApplicationId"
           android:value="@string/facebook_app_id" />
       <meta-data 
           android:name="com.facebook.sdk.ClientToken" 
           android:value="@string/facebook_client_token"/>
       ...
   </application>
   ```

4. **Package Visibility (`<queries>`)**:
   For Android 11+ (API 30+), add the package provider inside `<manifest>`:
   ```xml
   <queries>
       <provider android:authorities="com.facebook.katana.provider.PlatformProvider" />
   </queries>
   ```

5. **Key Hashes**:
   Make sure you generate and configure both your Debug and Release key hashes in the Meta Developers Console under Android Platform settings.

---

### iOS Configuration

1. **Minimum Deployment Target**:
   Requires iOS 13.0 or higher. In `ios/Podfile`:
   ```ruby
   platform :ios, '13.0'
   ```
   And in Xcode under **Runner > Deployment Info**, set the minimum target to `13.0`.

2. **Configure `Info.plist`**:
   Open `ios/Runner/Info.plist` as Source Code and add:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>fbYOUR_FACEBOOK_APP_ID</string>
       </array>
     </dict>
   </array>
   <key>FacebookAppID</key>
   <string>YOUR_FACEBOOK_APP_ID</string>
   <key>FacebookClientToken</key>
   <string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
   <key>FacebookDisplayName</key>
   <string>YOUR_APP_NAME</string>
   <key>LSApplicationQueriesSchemes</key>
   <array>
     <string>fbapi</string>
     <string>fb-messenger-share-api</string>
   </array>
   ```
   *(If you have other URL schemes like Google Sign-In, merge them into the same `CFBundleURLTypes` array).*

---

### Web Configuration

In your `main.dart`, initialize the Web SDK before `runApp()`:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_FACEBOOK_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v18.0",
    );
  }
  runApp(const MyApp());
}
```

> **Note**: Facebook JS SDK requires HTTPS (or `localhost` for local development).

---

### macOS Configuration

1. In `macos/Runner/Info.plist`, add network server permission:
   ```xml
   <key>com.apple.security.network.server</key>
   <true/>
   ```
2. In Xcode under **Signing & Capabilities**, enable **Outgoing Connections (Client)** and **Keychain Sharing** (used by `flutter_secure_storage` to persist session tokens).

3. In `main.dart`, initialize the plugin:
   ```dart
   import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     if (defaultTargetPlatform == TargetPlatform.macOS) {
       await FacebookAuth.i.webAndDesktopInitialize(
         appId: "YOUR_FACEBOOK_APP_ID",
         cookie: true,
         xfbml: true,
         version: "v18.0",
       );
     }
     runApp(const MyApp());
   }
   ```

4. **Meta Developer Console**:
   Under **Facebook Login > Settings**, set:
   - `Embedded browser OAuth login`: **Yes**
   - `Login with the JavaScript SDK`: **Yes**
   - `Allowed Domains for the JavaScript SDK`: `https://www.facebook.com/`

---

### Windows Configuration

Windows uses an embedded [Microsoft Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/) window to perform OAuth and intercept the redirect (matching macOS).

1. **Requirements**:
   - First build fetches the static WebView2 SDK via NuGet automatically.
   - Requires WebView2 Runtime installed on the end-user machine (bundled by default on Windows 11 and current Windows 10).
2. In `main.dart`, initialize with your App ID:
   ```dart
   import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     if (defaultTargetPlatform == TargetPlatform.windows) {
       await FacebookAuth.i.webAndDesktopInitialize(
         appId: "YOUR_FACEBOOK_APP_ID",
         cookie: true,
         xfbml: true,
         version: "v18.0",
       );
     }
     runApp(const MyApp());
   }
   ```
3. In Meta Developer Console under **Facebook Login > Settings**:
   - `Client OAuth login`: **Yes**
   - `Web OAuth login`: **Yes**
   - `Embedded browser OAuth login`: **Yes**
   - `Allowed Domains for the JavaScript SDK`: `https://www.facebook.com/`

---

## Usage

### Initialize (Web, macOS and Windows)

You can combine platform initialization for all desktop & web targets together in `main.dart`:

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_FACEBOOK_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v18.0",
    );
  }
  runApp(const MyApp());
}
```

---

### Login Request

```dart
final LoginResult result = await FacebookAuth.instance.login(); // Requests email & public_profile by default

if (result.status == LoginStatus.success) {
  final AccessToken accessToken = result.accessToken!;
  print("Token: ${accessToken.tokenString}");
} else {
  print("Status: ${result.status}");
  print("Message: ${result.message}");
}
```

#### Custom Permissions
```dart
final LoginResult result = await FacebookAuth.instance.login(
  permissions: ['public_profile', 'email', 'pages_show_list'],
);
```

---

### App Tracking Transparency & Limited Login (iOS)

On iOS, if App Tracking Transparency (ATT) is not requested or denied, the login enters [Limited Login mode](https://developers.facebook.com/docs/facebook-login/limited-login):

1. In `Info.plist`:
   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>We need tracking authorization to provide personalized experience.</string>
   ```
2. Request tracking before calling login (e.g. using `permission_handler`):
   ```dart
   import 'package:permission_handler/permission_handler.dart';

   await Permission.appTrackingTransparency.request();
   final LoginResult result = await FacebookAuth.instance.login();

   if (result.status == LoginStatus.success) {
     final AccessToken token = result.accessToken!;
     if (token is LimitedToken) {
       print("Logged in with Limited Login: ${token.tokenString}");
     } else if (token is ClassicToken) {
       print("Logged in with Classic Login: ${token.tokenString}");
     }
   }
   ```

---

### Check if User is Logged

```dart
final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
if (accessToken != null) {
  // User is logged in
}
```

---

### Get User Profile / Data

```dart
// Must have an active logged user
final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();
print(userData['name']);
print(userData['email']);
print(userData['picture']['data']['url']);

// Request custom fields
final customData = await FacebookAuth.instance.getUserData(
  fields: "name,email,picture.width(200),birthday,friends,gender",
);
```

---

### Express Login (Android)

```dart
final LoginResult result = await FacebookAuth.instance.expressLogin();
if (result.status == LoginStatus.success) {
  final AccessToken token = result.accessToken!;
}
```

---

### Log Out

```dart
await FacebookAuth.instance.logOut();
```

---

### Using with Firebase Auth

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential?> signInWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login();
  if (result.status == LoginStatus.success) {
    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  return null;
}
```
