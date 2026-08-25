# Windows support

Facebook publishes no native SDK for Windows, so this plugin does what the macOS
implementation does: it opens the Facebook OAuth dialog in an embedded webview and
reads the access token out of the redirect. On Windows that webview is
[Microsoft Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/).

## Requirements

**At build time** the WebView2 SDK is downloaded from NuGet the first time you build,
so your first Windows build needs an internet connection. The static loader is linked
in, so there is no extra DLL to ship alongside your application.

**At run time** the WebView2 Runtime must be present on the machine. It ships with
Windows 11 and with current Windows 10 installs; for older machines, bundle the
[Evergreen Runtime installer](https://developer.microsoft.com/microsoft-edge/webview2/)
with your app. If it is missing, `login()` fails with a `webview2_unavailable`
platform error rather than hanging.

Unlike iOS, Android and web, desktop apps do not store the Facebook session by
default, so this plugin uses `flutter_secure_storage` to keep the session data. On
Windows that needs no extra configuration — it encrypts with DPAPI under your app's
`%APPDATA%` folder.

WebView2 also keeps a browser profile of its own, in
`%LOCALAPPDATA%\facebook_auth_desktop`. The plugin clears cookies each time the login
window opens, so a previous login never silently re-authenticates, but the folder
itself persists between runs and is safe to delete.

## Initialize the plugin

As on macOS, you must initialize the plugin with your Facebook app id before calling
`login()`:

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

void main() async {
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v18.0",
    );
  }
  runApp(MyApp());
}
```

If your app also supports web and macOS, initialize for all of them:

```dart
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

void main() async {
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "YOUR_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v18.0",
    );
  }
  runApp(MyApp());
}
```

## Facebook console configuration

This is the same configuration macOS needs, and getting it wrong is the most common
reason the login window shows an error instead of the login form.

In your facebook console go to **Facebook Login > Settings** and set all of the
following under **Client OAuth settings**:

| Setting | Value |
| --- | --- |
| `Client OAuth login` | Yes |
| `Web OAuth login` | Yes |
| `Embedded browser OAuth login` | **Yes** — this is the webview flow the plugin uses |
| `Login from Devices` | Yes |
| `Login with the JavaScript SDK` | Yes |
| `Allowed Domains for the JavaScript SDK` | `https://www.facebook.com/` |

`Embedded browser OAuth login` is the one most often missed, and its description says
what it does: "Enable webview Redirect URIs for Client OAuth Login." The login window
*is* a webview, so with this off Facebook refuses the redirect.

Do **not** try to add the redirect to `Valid OAuth Redirect URIs`. That list is for
your own domains, and the console rejects the entry with "This can't be a Facebook
URL." The plugin redirects to `https://www.facebook.com/connect/login_success.html`,
which is Facebook's own page and is exempt from `Use Strict Mode for redirect URIs`
— that is why the field will not take it and why it does not need to.

Any of these being wrong produces the same unhelpful page: **"Can't load URL — The
domain of this URL isn't included in the app's domains"**. Work down the table rather
than trusting the message, which names only the app-domains field.

:::note
Keep in mind that this plugin uses the oauth flow facebook login, and in some cases if
the graph api doesn't return a `long_lived_token` the stored token will have a short
life time (80 minutes or less).
:::
