# flutter_facebook_auth
Flutter plugin to make easy the facebook authentication in your flutter app. iOS and Android are supported.


## **install on Android**
Go to https://developers.facebook.com/docs/facebook-login/android/?locale=en and read the next documentation. 
* Edit Your Resources and Manifest
* Associate Your Package Name and Default Class with Your App
* Provide the Development and Release Key Hashes for Your App


## **install on iOS** 
In your Podfile uncomment the next line (You need set the minimum target to 9.0 or higher)
```
platform :ios, '9.0'
```


Configure `Info.plist`

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

## **Important** 
The plugin is written in `Swift`, so your project needs to have Swift support enabled. If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.


## **Important**
To enable the login with the native facebook app on iOS you need add some code in your `ios/Runner/AppDelegate.swift`
```swift
import UIKit
import Flutter
import FBSDKCoreKit // <--- ADD THIS LINE

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)// <--- ADD THIS LINE
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // <--- OVERRIDE THIS METHOD WITH THIS CODE
    override func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
    }
}

```

for Objective-C (correctly works is not granted because this plugin was written with swift)

```objc
#import <FBSDKCoreKit/FBSDKCoreKit.h>


- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[ApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];
  // Add any custom logic here.
  return YES;
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url 
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

  BOOL handled = [[ApplicationDelegate sharedInstance] application:application
    openURL:url
    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
  ];
  // Add any custom logic here.
  return handled;
}
```


### **METHODS**
Just use `FacebookAuth.instance`. NOTE: all methods are **asynchronous**.

* `.login({List<String> permissions = const ['email', 'public_profile'] })` : request login with a list of permissions.

    The `public_profile` permission allows you read the next fields 
    `id, first_name, last_name, middle_name, name, name_format, picture, short_name`

    For more info go to https://developers.facebook.com/docs/facebook-login/permissions/

    return one instance of `LoginResult` class:
    ```
    { 
      status: 200,
      accessToken: { 
        expires: 1573493493209, 
        declinedPermissions: [], 
        permissions: [public_profile, email], 
        userId: 3003332493073668, 
        token: EAAVDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuyastmmkZBfwP7dKW6Xi4tvrTw8DToO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
      }
    }
    ```

    if `status` is 200 the login was successfull.





* `.logOut()` : close the current facebook session.

* `.isLogged` : check if the user has an active facebook session. The response will be `null` if the user is not logged.
       return one instance of `AccessToken` class:
    ```
    { 
        expires: 1573493493209, 
        userId: 3003332493073668, 
        token: EAATaHWA7VDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuytmmkZBfwP7dKW6Xi4XCO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
      }
    ```

*`.permissions(String token)`: get the granted and declined permissions.



* `.getUserData({String fields = "name,email,picture"})` : get the user info only if the user is logged.

    Expected response:
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _userData;
  String _token;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _printCredentials(LoginResult result) {
    _token = result.accessToken.token;
    print("userId: ${result.accessToken.userId}");
    print("token: $_token");
    print("expires: ${result.accessToken.expires}");
    print("grantedPermission: ${result.grantedPermissions}");
    print("declinedPermissions: ${result.declinedPermissions}");
  }

  _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken != null) {
      print("is Logged");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    final result = await FacebookAuth.instance.login();
    // final result = await FacebookAuth.instance.login(permissions:['email','user_birthday']);
    if (result.status == 200) {
      _printCredentials(result);
      // get the user data
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    } else if (result.status == 403) {
      print("login cancelled");
    } else {
      print("login failed");
    }
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    _token = null;
    setState(() {
      _userData = null;
    });
  }

  _checkPermissions() async {
    final dynamic response =
        await FacebookAuth.instance.permissionsStatus(_token);
    print("permissions: ${response.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_userData != null ? _userData.toString() : "NO LOGGED"),
            _userData != null
                ? CupertinoButton(
                    child: Text("Check permissions"),
                    onPressed: _checkPermissions,
                    color: Colors.greenAccent,
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
          ],
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
 AuthCredential credential =  FacebookAuthProvider.getCredential(accessToken: _token);
            

final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
```