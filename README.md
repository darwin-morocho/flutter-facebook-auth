# flutter_facebook_auth
Flutter plugin to make esay the facebook authentication


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

    expected response:
    ```json
    { 
      status: 200,
      accessToken: { 
        expires: 1573493493209, 
        declinedPermissions: [], 
        permissions: [public_profile, email], 
        userId: 3003332493073668, 
        token: EAATaHWA7VDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuytmmkZBfwP7dKW6Xi4tvrTw8DToLOGkBtAZBYeXpBWzkEF6l1hop5Lsk3jJBTZCmanue6irZAah7p0p70uB82Y5UHrAXCO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
      }
    }
    ```

    if `status` is 200 the login was successfull.





* `.logOut()` : close the current facebook session.

* `.isLogged()` : check if the user has an active facebook session. The response will be `null` if the user is not logged.
       expected response:
    ```json
    { 
        expires: 1573493493209, 
        declinedPermissions: [], 
        permissions: [public_profile, email], 
        userId: 3003332493073668, 
        token: EAATaHWA7VDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuytmmkZBfwP7dKW6Xi4tvrTw8DToLOGkBtAZBYeXpBWzkEF6l1hop5Lsk3jJBTZCmanue6irZAah7p0p70uB82Y5UHrAXCO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
      }
    ```

* `.getUserData({String fields = "name,email,picture"})` : get the user info only if the user is logged.

    Expected response:
    ```json
    { 
        expires: 1573493493209, 
        declinedPermissions: [], 
        permissions: [public_profile, email], 
        userId: 3003332493073668, 
        token: EAATaHWA7VDwBAE5lndhpg17DHFZABzh6QKiAZC42Qljcub9gib52L5CPEXvhk2ZBEa7LlOuytmmkZBfwP7dKW6Xi4tvrTw8DToLOGkBtAZBYeXpBWzkEF6l1hop5Lsk3jJBTZCmanue6irZAah7p0p70uB82Y5UHrAXCO2M2kMcau6CXsYtyys7WZAWV3XaMPnhuVauo5ghtGpnhJvZAtMKqlsgbV5GklPAYZD
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
  final _fb = FacebookAuth(); // new instance of FacebookAuth
  dynamic _userData;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _checkIfIsLogged() async {
    final accessToken = await _fb.isLogged();
    if (accessToken != null) {
      print("accessToken: ${accessToken.toString()}");
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
    if (result['status'] == LonginResult.success) {
      print("accessToken: ${result['accessToken'].toString()}");
      // get the user data
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      print("userData: ${userData.toString()}");
      setState(() {
        _userData = userData;
      });
    } else if (result['status'] == LonginResult.cancelled) {
      print("login cancelled");
    } else {
      print("login failed");
    }
  }

  _logOut() async {
    await _fb.logOut();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_userData != null ? _userData.toString() : "NO LOGGED"),
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


