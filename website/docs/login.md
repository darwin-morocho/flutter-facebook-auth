# Make a Login request

Just import the plugin.
```dart
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
```

Now you can use `FacebookAuth.instance` to call all the methods of the plugin.
The `login` method is **asynchronous**.

```dart
final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
if (result.status == LoginStatus.success) {
    // you are logged
    final AccessToken accessToken = result.accessToken!;
} else {
    print(result.status);
    print(result.message);
}
```

The `LoginResult` class has a field called `status` to check if the login was successful. 
If your are logged you can get one instance of `AccessToken` class and get a `token`(String) to make requests to the **Graph API**.

By default the `login` method makes a request with with the permissions to access `email` and `public_profile`. 
> The `public_profile` permission allows you read the next fields `id, first_name, last_name, middle_name, name, name_format, picture, short_name`

> For more info go to https://developers.facebook.com/docs/facebook-login/permissions/

If you would like to access other information of the user, you need to use the `permissions param` and pass it a `list` with the permissions.

Example:
```dart
final LoginResult result = await FacebookAuth.instance.login(
    permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],
);
// or 
// FacebookAuth.i.login(
//   permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],
// )
```

::: INFO
# App Tracking Transparency

Since **iOS 17** apple  all iOS apps must request the **AppTrackingTransparency** permission before the facebook login. 

 If the user has not granted the AdvertiserTracking permission, the login process will now enter a [Limited Login mode](https://developers.facebook.com/docs/facebook-login/limited-login).


In your `Info.plist` add the `NSUserTrackingUsageDescription` key only if you don't have it.
```
<key>NSUserTrackingUsageDescription</key>
<string>Your reason, why you want to track the user</string>
```

Next you need to ask to the user about the **AppTrackingTransparency** permission. To do that you can use [permission_handler](https://pub.dev/packages/permission_handler)

```dart
await Permission.appTrackingTransparency.request();
final LoginResult result = await FacebookAuth.instance.login();
```
:::

## BREAKING CHANGES TO SUPPORT THE LIMITED LOGIN
- iOS: Added `nonce` parameter in `login` function.
- **BREAKING CHANGE** Removed the `grantedPermissions` getter.
- **BREAKING CHANGE** Added support for limited login:
  - iOS: If the user has not granted the AdvertiserTracking permission, the login process will now enter a [Limited Login mode](https://developers.facebook.com/docs/facebook-login/limited-login).
  - Added enum `AccessTokenType`.
  - Added `LoginTracking` enum in the `login` function.
  - The `AccessToken` class is now abstract and now has 2 properties: `type` and `tokenString`.
  - Added subtypes `ClassicToken` and `LimitedToken` of `AccessToken`.
  - Please check the example project `facebook_auth/example/lib/login_page.dart`.

---
## Check if the user is logged.
> Just call to `FacebookAuth.instance.accessToken`
```dart
final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
if (accessToken != null) {
    // user is logged
}
```

---
## Log Out
> Just call to `FacebookAuth.instance.logOut()`

```dart
await FacebookAuth.instance.logOut();
// or FacebookAuth.i.logOut();
```
