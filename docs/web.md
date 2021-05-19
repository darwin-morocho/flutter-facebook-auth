
> Check a web demo [here](https://flutter-facebook-auth.web.app/)

🚫 _IMPORTANT:_ the facebook javascript SDK is only allowed to use with `https` but you can test the plugin in your localhost with an error message in your web console.

👉 The `accessToken` method only works in live mode using `https` and you must add your **OAuth redirect URL** in your _facebook developer console_.


Now you need to add the Facebook JavaScript SDK in your `index.html` at the top of your body tag.

```html
<!-- ADD THIS SCRIPT -->
<script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>
```

Example

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="/" />

    <meta charset="UTF-8" />
    <meta content="IE=Edge" http-equiv="X-UA-Compatible" />
    <meta
      name="description"
      content="Demonstrates how to use the flutter_facebook_auth plugin."
    />

    <!-- iOS meta tags & icons -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta
      name="apple-mobile-web-app-title"
      content="flutter_facebook_auth_example"
    />
    <link rel="apple-touch-icon" href="icons/Icon-192.png" />

    <link rel="icon" type="image/png" href="favicon.png" />

    <title>flutter_facebook_auth_example</title>
    <link rel="manifest" href="manifest.json" />
  </head>
  <body>
    <!-- START FACEBOOK SDK -->
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>
     <!-- END FACEBOOK SDK  -->
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

Now go to your `main.dart` file and in your `main` function initialize the facebook SDK.
```dart 
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; 
.
.
.
void main() {
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "1329834907365798",//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  runApp(MyApp());
}
```


!> On Web if the facebook SDK was not initialized by missing configuration or  content blockers all methods of this plugin will return null or a fail status depending of the method. You can check if the SDK was initialized using ` FacebookAuth.i.isWebSdkInitialized`.