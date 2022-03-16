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

The `AccessToken` class has two fields (only Android and iOS, on web these fields will be null) `grantedPermissions` and `declinedPermissions` to check the permissions granted for the user.

On web use `FacebookAuth.instance.permissions` to check the permissions granted for the user.
```dart
FacebookPermissions  permissions = await FacebookAuth.instance.permissions;
// or FacebookAuth.i.permissions
```

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
