<p align="center">
  <img src="https://user-images.githubusercontent.com/15864336/101827170-f5ce3180-3afd-11eb-9a60-5933a15f337b.png" alt="flutter_facebook_auth banner" width="100%"/>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flutter_facebook_auth"><img alt="pub version" src="https://img.shields.io/pub/v/flutter_facebook_auth?color=00b0ff&label=flutter_facebook_auth&style=flat-square"></a>
  <a href="https://pub.dev/packages/flutter_facebook_auth"><img alt="pub points" src="https://img.shields.io/pub/points/flutter_facebook_auth?color=2e7d32&style=flat-square"></a>
  <a href="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth"><img alt="codecov" src="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth/branch/master/graph/badge.svg?token=XEXUNVP0UK&style=flat-square"/></a>
  <img alt="license" src="https://img.shields.io/github/license/darwin-morocho/flutter-facebook-auth?style=flat-square"/>
  <a href="https://github.com/darwin-morocho/flutter-facebook-auth/stargazers"><img alt="stars" src="https://img.shields.io/github/stars/darwin-morocho/flutter-facebook-auth?style=flat-square&color=ffa000"/></a>
</p>

<p align="center">
  <strong>The complete, production-ready solution to integrate Facebook Login across all Flutter platforms.</strong>
</p>

---

## 📱 Platform Support

| Platform | Supported | SDK / Underlying Technology | Requirements |
| :--- | :---: | :--- | :--- |
| **Android** | ✅ | Native Facebook Android SDK | `minSdkVersion 21` (Android 5.0+) |
| **iOS** | ✅ | Native Facebook iOS SDK (v18.x) | iOS 13.0+, Supports Limited & Classic Login |
| **Web** | ✅ | Facebook JavaScript SDK | HTTPS or `localhost` |
| **macOS** | ✅ | Embedded Web OAuth (`WKWebView`) | macOS 10.15+, Keychain Sharing enabled |
| **Windows** | ✅ | Microsoft Edge WebView2 | Windows 10/11 |

---

## 📑 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Platform Setup](#-platform-setup)
  - [Android Setup](#android-setup)
  - [iOS Setup](#ios-setup)
  - [Web Setup](#web-setup)
  - [macOS Setup](#macos-setup)
  - [Windows Setup](#windows-setup)
- [Usage Guide](#-usage-guide)
  - [1. Initialize Desktop & Web](#1-initialize-desktop--web)
  - [2. Login Request](#2-login-request)
  - [3. iOS App Tracking Transparency & Limited Login](#3-ios-app-tracking-transparency--limited-login)
  - [4. Check Login Status & Active Token](#4-check-login-status--active-token)
  - [5. Fetch User Profile Data](#5-fetch-user-profile-data)
  - [6. Firebase Auth Integration](#6-firebase-auth-integration)
  - [7. Android Express Login](#7-android-express-login)
  - [8. Log Out](#8-log-out)
- [Common Issues & Solutions](#-common-issues--solutions)
- [Example App](#-example-app)
- [License](#-license)

---

## ✨ Features

- 🚀 **Full Cross-Platform**: Android, iOS, Web, macOS, and Windows.
- 🔒 **Apple Limited Login & ATT**: Full support for iOS 14.5+ App Tracking Transparency and Meta Limited Login OIDC tokens.
- 🔥 **Firebase Auth Ready**: Direct support for classic tokens and Limited Login JWT with raw nonce.
- ⚡ **Express Login**: Instant re-authentication on Android without prompts.
- 👤 **Graph API & Profile Data**: Fetch user email, name, avatar, or customized Graph API fields.
- 🛡️ **Session Persistence**: Secure multi-platform token storage.

---

## 📦 Installation

Add `flutter_facebook_auth` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_facebook_auth: ^7.3.2
```

Or install it via terminal:

```bash
flutter pub add flutter_facebook_auth
```

---

## ⚙️ Platform Setup

<details open>
<summary><b>🤖 Android Setup</b></summary>

> [!IMPORTANT]
> You must configure Android before running the app. Missing configuration will cause Facebook SDK initialization failure and trigger `MissingPluginException`.

1. **`minSdkVersion`**:
   In `android/app/build.gradle`, ensure `minSdkVersion` is at least `21`:
   ```gradle
   defaultConfig {
       minSdkVersion 21
   }
   ```

2. **Add App Credentials (`strings.xml`)**:
   In `/android/app/src/main/res/values/strings.xml` (create if it doesn't exist):
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
       <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
   </resources>
   ```
   *(Find the **Client Token** in Meta Developer Dashboard > App Settings > Advanced > Security > Client Token).*

3. **Manifest Configuration (`AndroidManifest.xml`)**:
   In `/android/app/src/main/AndroidManifest.xml`:
   ```xml
   <manifest xmlns:android="http://schemas.android.com/apk/res/android">
       <!-- 1. Internet Permission -->
       <uses-permission android:name="android.permission.INTERNET"/>

       <!-- 2. Queries for Android 11+ (API 30+) -->
       <queries>
           <provider android:authorities="com.facebook.katana.provider.PlatformProvider" />
       </queries>

       <application ...>
           <!-- 3. Meta Data Tags -->
           <meta-data
               android:name="com.facebook.sdk.ApplicationId"
               android:value="@string/facebook_app_id" />
           <meta-data 
               android:name="com.facebook.sdk.ClientToken" 
               android:value="@string/facebook_client_token" />

           <activity
               android:name="com.facebook.FacebookActivity"
               android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" />
           <activity
               android:name="com.facebook.CustomTabActivity"
               android:exported="true">
               <intent-filter>
                   <action android:name="android.intent.action.VIEW" />
                   <category android:name="android.intent.category.DEFAULT" />
                   <category android:name="android.intent.category.BROWSABLE" />
                   <data android:scheme="@string/fb_login_protocol_scheme" />
               </intent-filter>
           </activity>
       </application>
   </manifest>
   ```

4. **Key Hashes**:
   Generate your debug and release key hashes and register them in the **Meta Developers Console > App Settings > Basic > Android Platform**:
   ```bash
   # macOS / Linux (Debug)
   keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
   ```
   *(For Google Play Console releases, obtain the SHA-1 from **App Integrity > App Signing** and convert it to Base64).*

</details>

<details open>
<summary><b>🍎 iOS Setup</b></summary>

1. **Minimum Deployment Target**:
   Requires **iOS 13.0** or higher.
   In `ios/Podfile`:
   ```ruby
   platform :ios, '13.0'
   ```
   In Xcode: select **Runner > Deployment Info > Minimum Deployments** and set to `13.0`.

2. **Configure `ios/Runner/Info.plist`**:
   Open `ios/Runner/Info.plist` as source code and add the following keys inside `<dict>`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <!-- Must have prefix 'fb' followed by your App ID -->
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
   <!-- Required if using App Tracking Transparency (Classic Login) -->
   <key>NSUserTrackingUsageDescription</key>
   <string>This identifier will be used to deliver personalized ads and content.</string>
   ```

</details>

<details>
<summary><b>🌐 Web Setup</b></summary>

Initialize the Web SDK in `main.dart` before `runApp()`:

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

> [!NOTE]
> Facebook JavaScript SDK requires HTTPS or `localhost` during local development. In Meta Developer Console under **Facebook Login > Settings**, ensure **Login with the JavaScript SDK** is set to `Yes` and add your domain to **Allowed Domains for the JavaScript SDK**.

</details>

<details>
<summary><b>🖥️ macOS Setup</b></summary>

1. **Network Entitlement**:
   In `macos/Runner/Info.plist`, add:
   ```xml
   <key>com.apple.security.network.server</key>
   <true/>
   ```
2. **Xcode Capabilities**:
   Under **Signing & Capabilities**:
   - Enable **Outgoing Connections (Client)**.
   - Enable **Keychain Sharing** (used to persist tokens).
3. **Initialize in `main.dart`**:
   ```dart
   import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
   import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
4. **Meta Developer Console Settings**:
   Under **Facebook Login > Settings**:
   - `Client OAuth login`: **Yes**
   - `Web OAuth login`: **Yes**
   - `Embedded browser OAuth login`: **Yes**
   - `Allowed Domains for the JavaScript SDK`: `https://www.facebook.com/`

</details>

<details>
<summary><b>🪟 Windows Setup</b></summary>

Windows uses an embedded [Microsoft Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/) window to perform OAuth seamlessly:

1. **Prerequisites**:
   - Visual Studio 2019/2022 with "Desktop development with C++".
   - The build process automatically fetches the official Microsoft WebView2 NuGet package.
   - Windows 10/11 includes the WebView2 Runtime by default.
2. **Initialize in `main.dart`**:
   ```dart
   import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
   import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
3. **Meta Developer Console Settings**:
   Same as macOS (enable `Client OAuth login`, `Web OAuth login`, and `Embedded browser OAuth login`).

</details>

---

## 🚀 Usage Guide

### 1. Initialize Desktop & Web

You can combine initialization for all Desktop & Web targets in `main.dart`:

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
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

### 2. Login Request

Call `FacebookAuth.instance.login()` to initiate authentication:

```dart
final LoginResult result = await FacebookAuth.instance.login(); // default permissions: ['email', 'public_profile']

if (result.status == LoginStatus.success) {
  final AccessToken accessToken = result.accessToken!;
  print("User Token: ${accessToken.tokenString}");
  print("Expires: ${accessToken.expires}");
} else if (result.status == LoginStatus.cancelled) {
  print("Login cancelled by user");
} else {
  print("Login failed: ${result.message}");
}
```

#### Request Custom Permissions

```dart
final LoginResult result = await FacebookAuth.instance.login(
  permissions: ['public_profile', 'email', 'user_friends'],
);
```

---

### 3. iOS App Tracking Transparency & Limited Login

On iOS 14.5+, Meta enforces **Limited Login** unless the user grants App Tracking Transparency (ATT) permission:

- **Limited Login (Default without ATT)**: Returns an OpenID Connect (OIDC) JWT token (`LimitedToken`). Graph API queries are restricted by Meta for privacy.
- **Classic Login (ATT Granted)**: Returns a standard OAuth access token (`ClassicToken`) allowing unrestricted Graph API access.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> loginWithATTSupport() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    // Request tracking authorization for Classic Login
    final status = await Permission.appTrackingTransparency.request();
    print("ATT Status: $status");
  }

  final LoginResult result = await FacebookAuth.instance.login();

  if (result.status == LoginStatus.success) {
    final AccessToken token = result.accessToken!;
    if (token is LimitedToken) {
      print("Limited Login Token (JWT): ${token.tokenString}");
    } else if (token is ClassicToken) {
      print("Classic Login Token: ${token.tokenString}");
    }
  }
}
```

---

### 4. Check Login Status & Active Token

Check if an active session exists on app launch:

```dart
final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

if (accessToken != null) {
  print("User is already logged in with token: ${accessToken.tokenString}");
} else {
  print("No active Facebook session");
}
```

---

### 5. Fetch User Profile Data

Fetch user details from Facebook Graph API (requires Classic Login or granted permissions):

```dart
// Fetch default profile fields (name, email, picture, id)
final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();

print("User Name: ${userData['name']}");
print("User Email: ${userData['email']}");
print("Profile Picture: ${userData['picture']['data']['url']}");

// Fetch customized Graph API fields
final customData = await FacebookAuth.instance.getUserData(
  fields: "name,email,picture.width(400),birthday,gender",
);
```

> [!TIP]
> In iOS Limited Login mode, Graph API requests are blocked by Meta. The user's basic profile details (name, email, picture) are provided inside the `LimitedToken` payload itself or decoded from the JWT.

---

### 6. Firebase Auth Integration

Integrate seamlessly with `firebase_auth`. This snippet properly handles both **Classic Login** and **iOS Limited Login** (which requires `rawNonce` via `OAuthProvider`):

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential?> signInWithFacebookFirebase() async {
  final LoginResult result = await FacebookAuth.instance.login();

  if (result.status == LoginStatus.success) {
    final AccessToken accessToken = result.accessToken!;

    OAuthCredential credential;
    if (accessToken is LimitedToken) {
      // iOS Limited Login: Authenticate via OAuthProvider with idToken and rawNonce
      credential = OAuthProvider('facebook.com').credential(
        idToken: accessToken.tokenString,
        rawNonce: FacebookAuth.instance.nonce,
      );
    } else {
      // Classic Login (Android, Web, Desktop, iOS with ATT)
      credential = FacebookAuthProvider.credential(accessToken.tokenString);
    }

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  return null;
}
```

---

### 7. Android Express Login

Allows returning users to re-authenticate with a single tap on Android:

```dart
final LoginResult result = await FacebookAuth.instance.expressLogin();

if (result.status == LoginStatus.success) {
  print("Express login success: ${result.accessToken!.tokenString}");
}
```

---

### 8. Log Out

Sign out and clear stored session tokens across all platforms:

```dart
await FacebookAuth.instance.logOut();
```

---

## 🛠️ Common Issues & Solutions

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| `MissingPluginException` on Android | Missing configuration before calling SDK | Add `strings.xml`, `ApplicationId`, and `ClientToken` to `AndroidManifest.xml`. |
| `Bad signature / code 190` in Firebase Auth | Using `FacebookAuthProvider` with iOS Limited Login | Use `OAuthProvider('facebook.com').credential(idToken: token, rawNonce: rawNonce)` as shown above. |
| `Feature unavailable` / Login disabled | Meta App in Development Mode or pending Review | Set Meta App status to **Live** or add test users under App Roles in the Meta Console. |
| Crash on iOS when tapping login button | Missing `FacebookClientToken` in `Info.plist` | Add `FacebookClientToken` to `ios/Runner/Info.plist`. |
| `User cancelled` on Android | Key Hash mismatch in Meta Developer Console | Ensure both Debug and Release SHA-1 Base64 key hashes are registered in Meta Dashboard. |
| Empty user data `{}` on iOS | Graph API disabled in Limited Login | Request ATT permission for Classic Login or read profile data from `LimitedToken`. |

---

## 📱 Example App

A full multi-platform example showcasing login, permissions, user information, and error handling is available in the [`example`](example) directory.

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
