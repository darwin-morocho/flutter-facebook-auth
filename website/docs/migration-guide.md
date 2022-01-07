# Migration guide

Now the this flugin uses the swift facebook sdk 12.2.1 and the android facebook sdk 12.2.0

If you have a previous version of `flutter_facebook_auth: 4.0.0` you need to remove that version from your `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.0.2
  flutter_facebook_auth: 3.5.7 # <-- REMOVE THIS
```

Now run the command `flutter pub get`.
Next you need remove the previos version of the facebook sdk from your **Podfile.lock** (only iOS) just run the next command

```
cd ios && pod install
```

The above command will remove the old dependencies from the **Podfile.lock** file. Now add the new version of this plugin in your `pubspec.yaml`
