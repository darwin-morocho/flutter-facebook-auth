import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show visibleForTesting, defaultTargetPlatform, TargetPlatform;

import 'facebook_auth_plaftorm.dart';
import 'login_result.dart';
import 'access_token.dart';
import 'login_behavior.dart';

/// class to make calls to the facebook login SDK
class FacebookAuthPlatformImplementation extends FacebookAuthPlatform {
  /// check if is running on Android
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  @visibleForTesting
  MethodChannel channel =
      const MethodChannel('app.meedu/flutter_facebook_auth');

  /// make a login request using the facebook SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  ///
  /// [loginBehavior] (only Android) use this param to set the UI for the authentication,
  /// like webview, native app, or a dialog.
  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    LoginBehavior loginBehavior = LoginBehavior.dialogOnly,
    LoginTracking loginTracking = LoginTracking.enabled,
  }) async {
    try {
      final result = await channel.invokeMethod("login", {
        "permissions": permissions,
        "loginBehavior": getLoginBehaviorAsString(loginBehavior),
        "tracking": loginTracking.name,
      });
      final map = Map<String, dynamic>.from(result);

      final token = map['type'] == 'limited'
          ? LimitedToken.fromJson(map)
          : ClassicToken.fromJson(map);

      return LoginResult(status: LoginStatus.success, accessToken: token);
    } on PlatformException catch (e) {
      return LoginResult.getResultFromException(e);
    }
  }

  /// Express login logs people in with their Facebook account across devices and platform.
  /// If a person logs into your app on Android and then changes devices,
  /// express login logs them in with their Facebook account, instead of asking for them to select a login method.
  ///
  /// This avoid creating duplicate accounts or failing to log in at all. To support the changes in Android 11,
  /// first add the following code to the queries element in your /app/manifest/AndroidManifest.xml file.
  /// For more info go to https://developers.facebook.com/docs/facebook-login/android
  @override
  Future<LoginResult> expressLogin() async {
    if (isAndroid) {
      try {
        final result = await channel.invokeMethod("expressLogin");
        final token = ClassicToken.fromJson(Map<String, dynamic>.from(result));
        return LoginResult(status: LoginStatus.success, accessToken: token);
      } on PlatformException catch (e) {
        return LoginResult.getResultFromException(e);
      }
    }
    return LoginResult(
      status: LoginStatus.failed,
      message: 'Method only allowed on Android',
    );
  }

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    final result = await channel.invokeMethod("getUserData", {
      "fields": fields,
    });
    return isAndroid
        ? jsonDecode(result)
        : Map<String, dynamic>.from(result); //null  or dynamic data
  }

  /// Sign Out from Facebook
  @override
  Future<void> logOut() async {
    await channel.invokeMethod("logOut");
  }

  /// if the user is logged return one instance of AccessToken
  @override
  Future<AccessToken?> get accessToken async {
    final result = await channel.invokeMethod("getAccessToken");
    if (result != null) {
      final map = Map<String, dynamic>.from(result);

      return map['type'] == 'limited'
          ? LimitedToken.fromJson(map)
          : ClassicToken.fromJson(map);
    }
    return null;
  }

  /// only available on WEB
  @override
  Future<void> webAndDesktopInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) async {}

  /// use this to know if the facebook sdk was initializated on Web
  /// on Android and iOS is always true
  @override
  bool get isWebSdkInitialized => false;

  @override
  Future<bool> get isAutoLogAppEventsEnabled async {
    if (isIOS) {
      final enabled =
          await channel.invokeMethod<bool>("isAutoLogAppEventsEnabled");
      return enabled ?? false;
    }
    return false;
  }

  @override
  Future<void> autoLogAppEventsEnabled(bool enabled) async {
    if (isIOS) {
      await channel.invokeMethod("updateAutoLogAppEventsEnabled", {
        "enabled": enabled,
      });
    }
  }
}
