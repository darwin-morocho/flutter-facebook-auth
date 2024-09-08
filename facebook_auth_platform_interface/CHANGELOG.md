### 6.1.2
- mocktail: ^1.0.4

### 6.1.1
- Fixed AccessToken.fromJson on MacOS.

### 6.1.0
- Use dart >=3.3.0 <4.0.0

### 6.0.0
- Added `LoginTracking` enum.
- Added `ClassicToken` and `LimitedToken` classes.

### 5.0.0
- Use dart >=3.0.0 <4.0.0

### 4.1.1
- Fixed bug parsing `dataAccessExpirationTime` throws `String is not a subtype of int` on macOS.
### 4.1.0
- Added dataAccessExpirationTime to AccessToken.
### 4.0.1
- plugin_platform_interface: ^2.1.2
### 4.0.0
- **BREAKING CHANGE**
    Replaced `webInitialize` method for `webAndDesktopInitialize`.
### 3.2.0
- plugin_platform_interface: ^2.1.2
- mocktail: ^0.3.0

### 3.1.2
- Restored option `LoginBehavior.webOnly`.
### 3.1.1
- Removed deprecated option `LoginBehavior.webOnly`.

### 3.1.0
- Updated method `webInitialize`


### 3.0.1
- Removed deprecated `LoginBehavior.webViewOnly`.
### 3.0.0+1
* changes in FacebookAuthPlatform:

    ```dart
    static const _token = Object();
    ```
    to 
    ```dart
    static final _token = Object();
    ```


    Added `PlatformInterface.verifyToken(instance, _token);` in setter.

### 2.7.1
- Fixed Parse error for Facebook long-lived tokens. Thanks to [RomainFranceschini](https://github.com/RomainFranceschini)
### 2.7.0
- Added isAutoLogAppEventsEnabled only iOS.

### 2.6.1
- Fixed login ui webview to dialog on Android.
### 2.6.0
- Removed LoginBehavior and FacebookAuthErrorCode class.
- Added enum LoginBehavior.
- Improved tests.
### 2.5.0
- Added isWebSdkInitialized;

### 2.4.2
- Removed empty list on declinedPermissions and grantedPermissions.

### 2.4.1
- Removed kIsWeb on MethodChannel.
### 2.4.0
- Added FacebookPermissions.
- Added get permissions for web applications.

### 2.3.0
- Added webInitialize method for web.

### 2.2.0
- Removed FacebookAuthException class.
- Added LoginResult class.

### 2.1.1
- Updated the AccessToken class.


### 2.1.0-dev.0
- Renamed FacebookAuthPlatformInterface to FacebookAuthPlatform.
- Added unit test.

### 2.0.0
-  Release the null safety version.

### 2.0.0-nullsafety.2
-  plugin_platform_interface: ^2.0.0

### 2.0.0-nullsafety.1
-  Removed legacy library.

### 2.0.0-nullsafety.0
-  Migrated library to null safety.


## 1.0.1
- Updated flutter version


## 1.0.0
- Added common platform interface for the flutter_facebook_auth plugin.
