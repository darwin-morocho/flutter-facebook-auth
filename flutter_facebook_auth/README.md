![image](https://user-images.githubusercontent.com/15864336/101827170-f5ce3180-3afd-11eb-9a60-5933a15f337b.png)


<p align="center">
  <a href="https://pub.dev/packages/flutter_facebook_auth"><img alt="pub version" src="https://img.shields.io/pub/v/flutter_facebook_auth?color=%2300b0ff&label=flutter_facebook_auth&style=flat-square"></a>
  
  <img alt="last commit" src="https://img.shields.io/github/last-commit/the-meedu-app/flutter-facebook-auth?color=%23ffa000&style=flat-square"/> 
  <img alt="license" src="https://img.shields.io/github/license/the-meedu-app/flutter-facebook-auth?style=flat-square"/>
  <img alt="stars" src="https://img.shields.io/github/stars/the-meedu-app/flutter-facebook-auth?style=social"/>
</p>

---

## **Sumary**

- [Installation](#installation)
- [Android set up](#android)
- [iOS set up](#ios)
- [Methods](#methods)
- [Example](#example)
- [Using with firebase_auth](#using-with-firebase_auth)
- [Support for flutter Web](#add-support-to-flutter-web)

---
> See a complete video tutorial using `flutter_facebook_auth` (Spanish Only) https://www.youtube.com/watch?v=X-x5pHQ4Gz8&list=PLV0nOzdUS5XuWMzOCGZQPwCEZ1m5aZEo5
---

## **Installation**

First, add `flutter_facebook_auth` as a dependency in your pubspec.yaml file.

```yaml
flutter_facebook_auth: ^1.0.0
```

> When you install this plugin you need configure the plugin on Android and iOS before run the project . If you don't do it you will have a **No implementation found** error because the Facebook sdk will try to find the configuration. If you don't need the plugin yet please remove or comment it.
---

### **Android**

Go to [Facebook Login for Android - Quickstart](https://developers.facebook.com/docs/facebook-login/android/?locale=en)

1.  Select an App or Create a New App

       <img src="https://user-images.githubusercontent.com/15864336/98711287-cedfdc80-2352-11eb-9eb3-761f43ba4f7e.png" width="400" />

2.  Skip the step 2 (Download the Facebook App)
3.  Skip the step 3 (Integrate the Facebook SDK)
4.  Edit **Your Resources and Manifest** add this config in your android project

- Open your /app/res/values/strings.xml file.
- Add the following (replace `{your-app-id}` with your facebook app Id):

  ```xml
  <string name="facebook_app_id">{your-app-id}</string>
  <string name="fb_login_protocol_scheme">fb{your-app-id}</string>
  ```

  Here one example of `strings.xml`

  ```xml
  <?xml version="1.0" encoding="utf-8"?>
  <resources>
      <string name="app_name">Flutter Facebook Auth Example</string>
      <string name="facebook_app_id">1365719610250300</string>
      <string name="fb_login_protocol_scheme">fb1365719610250300</string>
  </resources>
  ```

- Open the `/app/manifest/AndroidManifest.xml` file.
- Add the following uses-permission element after the application element
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```
- Add the following meta-data element, an activity for Facebook, and an activity and intent filter for Chrome Custom Tabs inside your application element

```xml
<meta-data android:name="com.facebook.sdk.ApplicationId"
       android:value="@string/facebook_app_id"/>

   <activity android:name="com.facebook.FacebookActivity"
       android:configChanges=
               "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
       android:label="@string/app_name" />
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
```

Here one example of `AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
   package="app.meedu.flutter_facebook_auth_example">
   <uses-permission android:name="android.permission.INTERNET" />
   <application
       android:name="io.flutter.app.FlutterApplication"
       android:icon="@mipmap/ic_launcher"
       android:label="facebook auth">

       <meta-data
           android:name="com.facebook.sdk.ApplicationId"
           android:value="@string/facebook_app_id" />
       <activity
           android:name="com.facebook.FacebookActivity"
           android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
           android:label="@string/app_name" />
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


       <activity
           android:name=".MainActivity"
           android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
           android:hardwareAccelerated="true"
           android:launchMode="singleTop"
           android:theme="@style/LaunchTheme"
           android:windowSoftInputMode="adjustResize">
           <meta-data
               android:name="io.flutter.embedding.android.NormalTheme"
               android:resource="@style/NormalTheme" />
           <meta-data
               android:name="io.flutter.embedding.android.SplashScreenDrawable"
               android:resource="@drawable/launch_background" />
           <intent-filter>
               <action android:name="android.intent.action.MAIN" />
               <category android:name="android.intent.category.LAUNCHER" />
           </intent-filter>
       </activity>
       <meta-data
           android:name="flutterEmbedding"
           android:value="2" />
   </application>
</manifest>
```

5. Associate Your Package Name and Default Class with Your App

<img src="https://user-images.githubusercontent.com/15864336/98712455-54b05780-2354-11eb-9509-aa2846af1a2d.png" width="400" />

6. Provide the Development and Release Key Hashes for Your App

   <img src="https://user-images.githubusercontent.com/15864336/98712555-73aee980-2354-11eb-9c25-c1ef3760fce1.png" width="400" />

   To find info to how to generate you key hash go to https://developers.facebook.com/docs/facebook-login/android?locale=en_US#6--provide-the-development-and-release-key-hashes-for-your-app

   > Note: if your application uses [Google Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756?visit_id=637406280862877202-1623101210&rd=1) then you should get certificate SHA-1 fingerprint from Google Play Console and convert it to base64

   > You should add key hashes for every build variants like release, debug, CI/CD, etc.

---

Also if you want to add support for **express login** on Android go to
https://developers.facebook.com/docs/facebook-login/android/#expresslogin

> Check the example project to see a correct set up.

---

### **iOS**

> **You need Swift support**<br/>
> The plugin is written in `Swift`, so your project needs to have Swift support enabled. If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.

- In your Podfile uncomment the next line (You need set the minimum target to 9.0 or higher)

  ```
  platform :ios, '9.0'
  ```

- Go to **[Facebook Login for iOS - Quickstart
](https://developers.facebook.com/docs/facebook-login/ios)** and select or create your app.

   <img src="https://user-images.githubusercontent.com/15864336/98708293-0056a900-234f-11eb-9975-b75ca08b6470.png" width="400" />

- **Skip** the step 2 **(Set up Your Development Environment)**.

- In the step 3 (Register and Configure Your App with Facebook) you need add your `Bundle Identifier`

    <img src="https://user-images.githubusercontent.com/15864336/98708485-38f68280-234f-11eb-9d1a-7c970d04642a.png" width="400" />

  You can find you `Bundle Identifier` in Xcode (Runner - Target Runner - General)

  ![image](https://user-images.githubusercontent.com/15864336/98708171-e1581700-234e-11eb-8f94-23c0db55e8f0.png)

- In the Step 4 you need configure your `Info.plist` file inside `ios/Runner/Info.plist`

  From Xcode you can open your `Info.plist` as `Source Code` now add the next code and replace `{your-app-id}` with your facebook app Id.

    <img src="https://user-images.githubusercontent.com/15864336/98708650-66433080-234f-11eb-81c6-2297b9e6f7a7.png" width="400" />

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb{your-app-id}</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>{your-app-id}</string>
<key>FacebookDisplayName</key>
<string>{your-app-name}</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

> If you have implement another providers (Like Google) in your app you should merge values in Info.plist

Check if you already have CFBundleURLTypes or LSApplicationQueriesSchemes keys in your Info.plist. If you have, you should merge their values, instead of adding a duplicate key.

Example with Google and Facebook implemetation:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb{your-app-id}</string>
      <string>com.googleusercontent.apps.{your-app-specific-url}</string>
    </array>
  </dict>
</array>
```

To use any of the Facebook dialogs (e.g., Login, Share, App Invites, etc.) that can perform an app switch to Facebook apps, your application's Info.plist also needs to include: <dict>...</dict>)

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fbapi20130214</string>
  <string>fbapi20130410</string>
  <string>fbapi20130702</string>
  <string>fbapi20131010</string>
  <string>fbapi20131219</string>
  <string>fbapi20140410</string>
  <string>fbapi20140116</string>
  <string>fbapi20150313</string>
  <string>fbapi20150629</string>
  <string>fbapi20160328</string>
  <string>fbauth</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

## NOTE

for Objective-C projects (correctly works is not granted because this plugin was written with swift)

---

### **METHODS**

Just use `FacebookAuth.instance`. NOTE: all methods are **asynchronous**.

- `FacebookAuth.instance.login()` : request login with a list of permissions.

```dart
  Future<void> _login() async {
    try {
        // by default the login method has the next permissions ['email','public_profile']
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
      // get the user data
      final userData = await FacebookAuth.instance.getUserData();
      print(auserData);
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            print("login failed");
            break;
      }
    }
  }
```

> The `public_profile` permission allows you read the next fields
> `id, first_name, last_name, middle_name, name, name_format, picture, short_name`

> For more info go to https://developers.facebook.com/docs/facebook-login/permissions/

- `.logOut()` : close the current facebook session.

- `.isLogged` : check if the user has an active facebook session. The response will be `null` if the user is not logged.

  Expected response one instance of `AccessToken` class:

  ```json
  {
    "userId": "300333249307438",
    "token": "FACEBOOK_TOKEN",
    "expires": "2021-01-09T09:06:10.749",
    "lastRefresh": "2020-11-10T11:44:05.749",
    "applicationId": "1365719610250300",
    "graphDomain": "facebook",
    "isExpired": false,
    "grantedPermissions": ["email", "user_link"],
    "declinedPermissions": []
  }
  ```

  Example

  ```dart
  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken != null) {
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
    }
  }
  ```

- `.getUserData({String fields = "name,email,picture"})` : get the user info only if the user is logged.

> Only call this method if you have an user Logged

Expected response `Map<String,dynamic>`:

```
{
email = "dsmr.apps@gmail.com";
id = 3003332493073668;
name = "Darwin Morocho";
picture =     {
    data =         {
        height = 50;
        "is_silhouette" = 0;
        url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3003332493073668&height=50&width=50&ext=1570917120&hash=AeQMSBD5s4QdgLoh";
        width = 50;
    };
};
}
```

### **EXAMPLE**

```dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(MyApp());
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _userData;
  AccessToken _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken.toJson()),
    );
  }

  Future<void> _login() async {
    try {
      // show a circular progress indicator
      setState(() {
        _checking = true;
      });
      _accessToken = await FacebookAuth.instance.login(); // by the fault we request the email and the public profile
      // loginBehavior is only supported for Android devices, for ios it will be ignored
      // _accessToken = await FacebookAuth.instance.login(
      //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      //   loginBehavior:
      //       LoginBehavior.DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
      // );
      _printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
    } on FacebookAuthException catch (e) {
      // if the facebook login fails
      print(e.message); // print the error message in console
      // check the error type
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    } catch (e, s) {
      // print in the logs the unknown errors
      print(e);
      print(s);
    } finally {
      // update the view
      setState(() {
        _checking = false;
      });
    }
  }


  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: _checking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _userData != null ? prettyPrint(_userData) : "NO LOGGED",
                      ),
                      SizedBox(height: 20),
                      _accessToken != null
                          ? Text(
                              prettyPrint(_accessToken.toJson()),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      CupertinoButton(
                        color: Colors.blue,
                        child: Text(
                          _userData != null ? "LOGOUT" : "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _userData != null ? _logOut : _login,
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
```

## **Using with firebase_auth**

```dart
import 'package:firebase_auth/firebase_auth.dart';
.
.
.
.


final FirebaseAuth _auth = FirebaseAuth.instance;
.
.
.

 // this line do auth in firebase with your facebook credential. Just pass your facebook token (String)
 final OAuthCredential credential =  FacebookAuthProvider.credential( _accessToken.token); // _token is your facebook access token as a string

// FirebaseUser is deprecated
final User user = (await _auth.signInWithCredential(credential)).user;
```


## **Add Support to flutter Web**
Donwload the [flutter_facebook_auth.js](https://raw.githubusercontent.com/darwin-morocho/flutter-facebook-auth/master/flutter_facebook_auth/example/web/flutter_facebook_auth.js) file and put it into your `web` folder.

<img  src="https://user-images.githubusercontent.com/15864336/101827813-bf44e680-3afe-11eb-9176-4e6ec9528d0c.png" width="300" />

Now you need define your `FACEBOOK_APP_ID` and the `flutter_facebook_auth.js` script in your `index.html` in the `head` section.

```html
  <script>
      const FACEBOOK_APP_ID = "YOUR_FACEBOOK_APP_ID";
  </script>
  <script src="flutter_facebook_auth.js" defer></script>
```
Example
```html
<!DOCTYPE html>
<html>
  <head>
    <base href="/" />

    <meta charset="UTF-8" />
    <meta content="IE=Edge" http-equiv="X-UA-Compatible" />
    <meta name="description" content="Demonstrates how to use the flutter_facebook_auth plugin." />

    <!-- iOS meta tags & icons -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="apple-mobile-web-app-title" content="flutter_facebook_auth_example" />
    <link rel="apple-touch-icon" href="icons/Icon-192.png" />

    <link rel="icon" type="image/png" href="favicon.png" />

    <title>flutter_facebook_auth_example</title>
    <link rel="manifest" href="manifest.json" />
    <script>
      const FACEBOOK_APP_ID = "1329834903456798";
    </script>
    <script src="flutter_facebook_auth.js" defer></script>
  </head>
  <body>
    <script>
      if ("serviceWorker" in navigator) {
        window.addEventListener("flutter-first-frame", function () {
          navigator.serviceWorker.register("flutter_service_worker.js");
        });
      }
    </script>
    <script src="main.dart.js" type="application/javascript"></script>
  </body>
</html>

```

