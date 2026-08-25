## 2.3.0
- Added Windows support. `signIn` opens the Facebook OAuth dialog in an embedded Microsoft Edge WebView2 window and intercepts the redirect the same way the macOS implementation does.
- The WebView2 SDK is fetched from NuGet at build time and linked statically, so no extra DLL has to be shipped with the app. End users need the WebView2 Runtime, which is preinstalled on Windows 11 and current Windows 10.

## 2.2.0
- Added Swift Package Manager (SPM) support for macOS. The plugin now ships a `Package.swift` (sources under `macos/facebook_auth_desktop/Sources/`) while keeping the podspec for CocoaPods compatibility.

## 2.1.3
- Bumped `flutter_secure_storage` dependency to `^10.3.1`.

## 2.1.0
- flutter_facebook_auth_platform_interface: ^6.1.2

## 2.1.0
- Fixed login canceled catch.
- flutter_facebook_auth_platform_interface: ^6.1.0
- flutter_secure_storage: ^9.2.2
- http: ^1.2.2

## 2.0.0
- flutter_facebook_auth_platform_interface: ^6.0.0


## 1.0.3
- Fixed [issue #389](https://github.com/darwin-morocho/flutter-facebook-auth/issues/389)

## 1.0.2
- Fixed null saved access token due to a flutter_secure_storage bug.

## 1.0.1
- flutter_secure_storage: ^9.0.0

### 1.0.0
- Use dart >=3.0.0 <4.0.0
- http > 1.0.0

## 0.0.8
- flutter_secure_storage: ^8.0.0
## 0.0.8
- flutter_secure_storage: ^7.0.1
## 0.0.7
- fixed `expires_in` time.
## 0.0.6
- fixed `long_lived_token` is null on macOs.
## 0.0.5
- flutter_facebook_auth_platform_interface: ^4.1.1
## 0.0.4
- flutter_facebook_auth_platform_interface: ^4.1.0

## 0.0.3
- http: ^0.13.5
- flutter_secure_storage: ^6.0.0 
## 0.0.2
- flutter_facebook_auth_platform_interface: ^4.0.1

## 0.0.1
- Added support for macOS
