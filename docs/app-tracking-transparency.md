# App Tracking Transparency

Since **iOS 14.5** all apps that they want to track the user activity to share data across others providers needs to request
the **AppTrackingTransparency** permission. 

If you want to track the user activity after the login process follow the next steps.

In your `Info.plist` add the `FacebookAutoLogAppEventsEnabled` key only if you don't have it and set the value to `false`
```
<key>FacebookAutoLogAppEventsEnabled</key>
<false/>
```
Also if you don't have the `NSUserTrackingUsageDescription` key you need to add it
```
<key>NSUserTrackingUsageDescription</key>
<string>Your reason, why you want to track the user</string>
```

Next you need to ask to the user about the **AppTrackingTransparency** permission. To do that you can use [permission_handler](https://pub.dev/packages/permission_handler)

```dart
final status = await Permission.appTrackingTransparency.request();
if (status == PermissionStatus.granted) {
  await FacebookAuth.i.autoLogAppEventsEnabled(true);
  print("isAutoLogAppEventsEnabled:: ${await FacebookAuth.i.isAutoLogAppEventsEnabled}");
}
```

You can use `FacebookAuth.i.isAutoLogAppEventsEnabled` to check if the AutoLogAppEvents are enabled.


> For more info check the example folder.
