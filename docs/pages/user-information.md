To get the user information just call to `getUserData` method.

```dart
final userData = await FacebookAuth.instance.getUserData();
```

> Only call `getUserData` method if you have an user Logged

Expected response `Map<String,dynamic>`:

```dart
{
    "email" = "dsmr.apps@gmail.com",
    "id" = 3003332493073668,
    "name" = "Darwin Morocho",
    "picture" = {
        "data" = {
            "height" = 50,
            "is_silhouette" = 0,
            "url" = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3003332493073668",
            "width" = 50,
        },
    }
}
```

> by default the `getUserData` method requests the `name, email and picture profile`. If you want to get to other user info you need to use the `fields` param.

For example if you want to get the user birthday, friends, gender and link you need first make a login request with these permissions.

```dart
final result = await FacebookAuth.instance.login(
    permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
);
if (result.status == LoginStatus.success) {
    final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200),birthday,friends,gender,link",
    );
}
```