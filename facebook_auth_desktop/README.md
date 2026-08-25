# flutter_facebook_auth_desktop

The desktop implementation of the [flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth)
plugin, covering **macOS** and **Windows**.

Both platforms use the same approach: because Facebook has no native desktop SDK, the OAuth
dialog is loaded in an embedded webview (`WKWebView` on macOS, `WebView2` on Windows) and the
navigation to the redirect URL is intercepted to read the access token out of its fragment.

## Usage

This package is endorsed by `flutter_facebook_auth`, so adding that package is enough — you do
not need to depend on `facebook_auth_desktop` directly.

On desktop you must initialize the plugin with your Facebook app id before calling `login()`:

```dart
await FacebookAuth.instance.webAndDesktopInitialize(
  appId: "YOUR_APP_ID",
  cookie: true,
  xfbml: true,
  version: "v18.0",
);
```

## Windows requirements

The plugin renders the login dialog with the
[Microsoft Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/) control.

- **At build time** the WebView2 SDK is downloaded from NuGet the first time you build, so the
  first Windows build needs an internet connection. The static loader is linked in, so there is
  no extra DLL to ship.
- **At run time** the WebView2 Runtime must be present. It ships with Windows 11 and with
  current Windows 10 installs; for older machines, bundle the
  [Evergreen Runtime installer](https://developer.microsoft.com/microsoft-edge/webview2/) with
  your app. If it is missing, `login()` fails with a `webview2_unavailable` platform error.
