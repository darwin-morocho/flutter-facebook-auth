# flutter_facebook_auth
Flutter plugin to make easy the facebook authentication in your flutter app. iOS and Android are supported.


## **install on Android**
Go to https://developers.facebook.com/docs/facebook-login/android/?locale=en and read the next documentation. 
* Edit Your Resources and Manifest
* Associate Your Package Name and Default Class with Your App
* Provide the Development and Release Key Hashes for Your App


## **install on iOS** 
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

### **METHODS**
fisrt create a new instance of FacebookAuth. NOTE: all methods are **asynchronous**.

* `.login({List<String> permissions = const ['email', 'public_profile'] })` : request login with a list of permissions.

    The `public_profile` permission allows you read the next fileds 
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

* `.isLogged()` : check if the user has an active facebook session. The response will be `null` if the user is not logged.
       return one instance of `AccessToken` class:
    ```
    { 
        expires: 1573493493209, 
        declinedPermissions: [], 
        permissions: [public_profile, email], 
        userId: 3003332493073668, 
        token: EAATaHWA7VDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuytmmkZBfwP7dKW6Xi4XCO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
      }
    ```

  NOTE: `declinedPermissions` and `permissions` are null on iOS, please use the method `permissionsStatus(String token)`



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
  final _fb = FacebookAuth();
  dynamic _userData;
  String _token;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _printCredentials(AccessToken accessToken) {
    _token = accessToken.token;
    print("userId: ${accessToken.userId}");
    print("token: $_token");
    print("expires: ${accessToken.expires}");
    print("permissions: ${accessToken.permissions.toString()}");
  }

  _checkIfIsLogged() async {
    final accessToken = await _fb.isLogged();
    if (accessToken != null) {
      _printCredentials(accessToken);
      // now you can call to  _fb.getUserData();
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    final result = await _fb.login();
    // final result = await _fb.login(permissions:['email','user_birthday']);
    print("login result ${result.toString()}");
    if (result.status == 200) {
      _printCredentials(result.accessToken);
      // get the user data
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
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
    await _fb.logOut();
    _token = null;
    setState(() {
      _userData = null;
    });
  }

  _checkPermissions() async {
    final dynamic response = await _fb.permissionsStatus(_token);
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
                onPressed: _userData != null ? _logOut : _login),
          ],
        ),
      ),
    );
  }
}
```


## **Using with firebase_auth**
Just create a credential like
```dart
 // this line do auth in firebase with your facebook credential.
 AuthCredential credential =  FacebookAuthProvider.getCredential(accessToken: _token);
            

final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
```