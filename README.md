# flutter_facebook_auth
Flutter plugin to make esay the facebook authentication

## ***Getting Started***
IMPORTANT for now only iOS is support. Android support is coming.


## install on iOS 


Configure Info.plist

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



## **how to use**

❗️Please check the example project

first import the plugin
``` dart
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
```

### **LOGIN**

use the method `FacebookAuth.login(permissions:)`

```dart
  _login() async {
    final result = await FacebookAuth.login();
    // final result = await FacebookAuth.login(permissions:['email','user_birthday']);
    if (result['status'] == 200) {
      setState(() {
        _isLogged = true;
      });
      print("accessToken: ${result['accessToken']}");
      // get the user data
      final userData = await FacebookAuth.getUserData();
      // final userData = await FacebookAuth.getUserData(fields:"email,birthday");
      print("userData: ${userData.toString()}");
    } else if (result['status'] == 403) {
      print("login cancelled");
    }
  }
```

Only if the user is logged you can call the method `FacebookAuth.getUserData`


### **LOGOUT**
```dart
  _logOut() async {
    await FacebookAuth.logOut();
    print("finished  logOut");
  }
```




The `public_profile` permission allows you read the next fileds 

* id
* first_name
* last_name
* middle_name
* name
* name_format
* picture
* short_name

For more info go to https://developers.facebook.com/docs/facebook-login/permissions/
