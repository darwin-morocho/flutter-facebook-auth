Now the this flugin uses the swift facebook sdk 9.1.0 and the android facebook sdk 9.1.0

If you have a previous version of `flutter_facebook_auth: 3.2.0` you need remove that version from your `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.0.2
  flutter_facebook_auth: 3.1.1 # <-- REMOVE THIS
```

Now run the command `flutter pub get`.
Next you need remove the previos version of the facebook sdk from your **Podfile.lock** (only iOS) just run the next command

```
cd ios && pod install
```

The above command will remove the old dependencies from the **Podfile.lock** file. Now add the new version of this plugin in your `pubspec.yaml`

!> For web the `flutter_facebook_auth.js` file is not more need it and in your `index.html` you only need to add the facebook sdk script (check the new [documentation](#add-support-for-flutter-web)).

!> The **FacebookAuthException** class was removed now you need to use the LoginResult class to check if your login was successful.

```dart
 final LoginResult result = await FacebookAuth.instance.login();
 if (result.status == LoginStatus.success) {
    final accessToken = result.accessToken;
  } else {
    print(result.status);
    print(result.message);
  }
```
