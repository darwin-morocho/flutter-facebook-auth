### 6.0.2
- Updated to `facebook_auth_desktop: ^1.0.1`

### 6.0.1
- Updated Facebook iOS SDK to 16.1.3
- Updated Facebook Android SDK to 16.1.3

### 6.0.0
- **BREAKING CHANGE**  since 6.x version your project must use dart 3.x or or higher.
In your `pubspec.yaml` make sure that you are using dart 3.x or or higher.
 ```yaml 
environment:
  sdk: ">=3.0.0 <4.0.0"
 ```

- Updated to `flutter_facebook_auth_platform_interface: ^5.0.0`.
- Updated to `flutter_facebook_auth_web: ^5.0.0`.
- Updated to `facebook_auth_desktop: ^1.0.0`


### version: 5.0.11
- Android (Add support of namespace property to support AGP 8)
### version: 5.0.10
- Removed java constraints.

### version: 5.0.9
- Updated Facebook iOS SDK to 16.0.1
- Updated Facebook Android SDK to 16.0.1

### version: 5.0.8
- Updated to `facebook_auth_desktop: ^0.0.9`
### version: 5.0.7
- Updated to `facebook_auth_desktop: ^0.0.8`

### version: 5.0.6
- fixed `expires_in` time on macOS.
NOTE (macOS): keep in mind that this plugin uses the oauth flow facebook login
and in some cases if the graph api doesn't return a `long_lived_token`
the token stored in the keychain will have a sort live time (80 minutes aprox).
### version: 5.0.5
- fixed `long_lived_token` is null on macOS.
### version: 5.0.4
- Removed FBSDKCoreKit from ios.
### version: 5.0.3
- Fixed bug parsing `dataAccessExpirationTime` throws `String is not a subtype of int` on macOS.
- Updated to `flutter_facebook_auth_platform_interface: ^4.1.1`.
- Updated to `flutter_facebook_auth_web: ^4.1.1`.
- Updated to `facebook_auth_desktop: ^0.0.5`
### version: 5.0.2
- Added FBSDKCoreKit on iOS.
- Updated Facebook iOS SDK to 15.1.0

### version: 5.0.1
- Android -> Replaced `jcenter` repository for `mavenCentral`.
### version: 5.0.0+2
- Updated min dart sdk version to 2.14.0.
### version: 5.0.0+1
- Updated readme.
### version: 5.0.0
- Added macOS support.
- Updated to `facebook_auth_desktop: ^0.0.4`
- Updated Facebook iOS SDK to 15.0.0
- Updated Facebook Android SDK to 15.0.2

### version: 5.0.0-dev.3
- Updated to `flutter_facebook_auth_platform_interface: ^4.0.1`.
### version: 5.0.0-dev.1
- Added macOS documentation.
### version: 5.0.0-dev.0
- **BREAKING CHANGE**
    Replaced `webInitialize` method for `webAndDesktopInitialize`.
- Added macOS support.
- Updated to `flutter_facebook_auth_platform_interface: ^4.0.0`.
- Updated to `flutter_facebook_auth_web: ^4.0.0`.
### 4.4.1+1
- Updated Facebook Android SDK to 14.1.1
### 4.4.0+1
- Updated plugin description.
### 4.4.0
- Updated to `flutter_facebook_auth_platform_interface: ^3.2.0`.
- Updated to `flutter_facebook_auth_web: ^3.2.0`.
- Updated Facebook Android SDK to 14.0.0
- Updated Facebook iOS SDK to 14.0.0

### 4.3.4+2
- Updated Facebook iOS SDK to 13.2.0
- Removed FBSDKCoreKit on iOS

### 4.3.4
- Updated Facebook Android SDK to 13.2.0

### 4.3.3
- fixed issue on Android due to LoginBehavior.webOnly
### 4.3.2
- Updated to `flutter_facebook_auth_platform_interface: ^3.1.2`.
- Updated to `flutter_facebook_auth_web: ^3.1.2`.

### 4.3.1
- Updated to `flutter_facebook_auth_platform_interface: ^3.1.1`.
- Updated to `flutter_facebook_auth_web: ^3.1.1`.

### 4.3.0
- Updated Facebook Android SDK to 13.+
- Updated Facebook iOS SDK to ~> 13

### 4.2.1
- Updated Facebook Android SDK to 13.0.0
- Updated Facebook iOS SDK to 13.0.0
### 4.2.0
- Updated to `flutter_facebook_auth_platform_interface: ^3.2.0`.
- **BREAKING on web** now the `webInitialize` method is asynchronous.
  the script to add the facebook sdk is not needed any more in the `index.html` file.
  Now just use async/await in your main
  ```dart
    void main() async {
      if (kIsWeb) {
        await FacebookAuth.i.webInitialize(
          appId: "YOUR_FACEBOOK_APP_ID",
          cookie: true,
          xfbml: true,
          version: "v13.0",
        );
      }
      runApp(MyApp());
    }
  ```
### 4.1.1
- Updated Facebook iOS SDK to 12.3.2
### 4.1.0
- Updated Facebook Android SDK to 12.3.0
- Updated Facebook iOS SDK to 12.3.1
### 4.0.1
- removed `jcenter` from `build.gradle`.
### 4.0.0
- Updated Facebook Android SDK to 12.2.0
- Updated Facebook iOS SDK to 12.2.1
- Removed deprecated `LoginBehavior.webViewOnly`.
- Removed `implements FacebookAuthPlatform` from `FacebookAuth` class.
- Updated to `flutter_facebook_auth_platform_interface: ^3.0.1`.
- Updated to `flutter_facebook_auth_web: ^3.0.0+1`.

### 3.5.7
- Fixed Parse error for Facebook long-lived tokens. Thanks to [RomainFranceschini](https://github.com/RomainFranceschini)
### 3.5.6+3
- revert minSdkVersion on Android.
### 3.5.6+2
- Updated Facebook Android SDK to 12.1.0
### 3.5.6+1
- Updated Facebook iOS SDK to 12.1.0
### 3.5.6
- Updated deprecated code on iOS.
### 3.5.5+1
- Refactor some code in `FacebookAuth.swift`

before
```
if let applicationWindow = UIApplication.shared.delegatewindow {
    return applicationWindow
}
```

now
```
let applicationWindow = UIApplication.shared.delegate?.window
if applicationWindow != nil {
    return applicationWindow!!
}
```

### 3.5.5
- Added `if #available(iOS 13.0, *)`on iOS. 
### 3.5.4
- Added minimum support for UIScene on iOS (Thanks to [@marcotta](https://github.com/darwin-morocho/flutter-facebook-auth/pull/181))
### 3.5.3
- Updated Facebook iOS SDK to 12.0.2
- Updated Facebook Android SDK to 12.0.1

### 3.5.2
- Updated Facebook iOS SDK to 11.2.0
### 3.5.1
- updated 'facebook-android-sdk' ~> 11.1.1
### 3.5.0+1
- updated 'FBSDKCoreKit' ~> 11.1.0
- updated 'FBSDKLoginKit' ~> 11.1.0

### 3.5.0
- Added isAutoLogAppEventsEnabled only iOS.
- Added autoLogAppEventsEnabled method only iOS.

### 3.4.1
- Updated flutter_facebook_auth_platform_interface: ^2.6.1
- Fixed login ui webview to dialog on Android.
### 3.4.0
- Updated to `flutter_facebook_auth_platform_interface:^ 2.6.0`
- Updated to `flutter_facebook_auth_web: ^2.6.0`
- Removed LoginBehavior and FacebookAuthErrorCode class.
- Added LoginBehavior enum.

### 3.3.4
- Added boolean isWebSdkInitialized;
### 3.3.3+1
- Updated documentation.

### 3.3.3
- Added control to solve "User logged in as a different facebook user" on Android.
### 3.3.2+2
- Updated to `flutter_facebook_auth_platform_interface:^ 2.4.1`
- Updated to `flutter_facebook_auth_web: ^2.4.1+1`

### 3.3.2+1
- Added code coverage badge in documentation.
### 3.3.2
- Fixed unhandled exception for "exceeded the rate limit" on web.

### 3.3.1+1
- Updated README.

### 3.3.1
- Updated AccessToken class.
- Added FacebookPermissions.
- Added get permissions for web applications.
- Updated README.

### 3.3.0+2
- Updated README.
### 3.3.0+1
- Removed interop file image.
### 3.3.0
- Removed `flutter_facebook_auth.js` file.
- Added webInitialize method.
### 3.2.0
- Removed FacebookAuthException class.
- Added LoginResult class.
- Updated README.
- Updated example.

### 3.1.1
- Fixed log "FBSDKGraphRequestConnection cannot be started before Facebook SDK initialized" on iOS.

### 3.1.0+1
- Updated README.
- Updated flutter_facebook_auth_web and flutter_facebook_auth_platform_interface.

### 3.1.0-dev.0
- Updated web example.
- Updated flutter_facebook_auth.js file.
- Updated flutter_facebook_auth_web and flutter_facebook_auth_platform_interface.

### 3.0.0+1
- Updated README. 

### 3.0.0
- Added support for flutter 2 and null safety. Thansk [@samlythemanly](https://github.com/samlythemanly). 
### 3.0.0-nullsafety.1
- flutter_facebook_auth_platform_interface: ^2.0.0-nullsafety.2

### 3.0.0-nullsafety.0
-  Migrated library to null safety.

### 2.0.2
-  Removed unnecessary kotlin file on Android.

### 2.0.1
-  Support for FB SDK 9.0.0 on iOS.
### 2.0.0+1
-  Updated readme.md.
### 2.0.0
-  Added support for flutter web.

### 2.0.0-web.9
-  Updated flutter_facebook_auth.js url.

### 2.0.0-web.8
-  Updated flutter_facebook_auth_web:^1.0.5

### 2.0.0-web.7
-  Updated documentation

### 2.0.0-web.6
-  Updated flutter_facebook_auth_web:^1.0.4

### 2.0.0-web.5
-  Updated flutter_facebook_auth_web:^1.0.3

### 2.0.0-web.4
-  Updated flutter_facebook_auth_web:^1.0.2

### 2.0.0-web.3
-  Updated flutter_facebook_auth_web.

### 2.0.0-web.2
-  Updated Readme.


### 2.0.0-web.1
-  Pre-release version to support for flutter web.


## 1.0.2+2
- Updated documentation.

## 1.0.2+1
- Updated documentation.
## 1.0.2
- Added loginBehavior (Android) to allow select the auth UI like webview, native app or dialogs.


## 1.0.1
- Updated on iOS FBSDKCoreKit to ~> 8.2.0
- Updated on iOS FBSDKLoginKit to ~> 8.2.0

## 1.0.0+4
- Updated documentation.


## 1.0.0+3
- Format code.

## 1.0.0+2
- Added dartdoc comments.


## 1.0.0+1
- Updated documentation.

## 1.0.0
- Removed LoginResult class.
- Updated docs.
- Updated Facebook SDK to ^8.1.0
- Added FacebookAuthException class.

## 0.3.3
- removed http and meta packages

## 0.3.2
- flutter: ">=1.10.0 <2.0.0"

## 0.3.1+1
- Added badge version

## 0.3.1
- Updated FBSDKCoreKit and FBSDKLoginKit to ~> 7.1.0 on iOS

## 0.3.0
- Added granted and declined permissions on AccessToken class, and removed AppDelegate.swift
- Updated example
- Updated documentation

## 0.2.4
- Updated documentation and isLogged method to catch posible exceptions

## 0.2.3
- Updated to Supporting the new Android plugins APIs

## 0.2.2+3
- Removed dangerous log

## 0.2.2+2
- Updated Docs to allow login with facebook and twitter in the same flutter app

## 0.2.2+1
- Updated Readme.md

## 0.2.2
- Added documentation for ApplicationDelegate.shared on iOS

## 0.2.1
- Removed dangerous log

## 0.2.0
- Updated Facebook Core version to remove deprecated UIWebView on iOS.
- Updated methods.


## 0.1.1
- iOS version