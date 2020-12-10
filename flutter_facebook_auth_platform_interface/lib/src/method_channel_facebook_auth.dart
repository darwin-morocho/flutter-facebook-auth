import 'dart:convert';
import 'package:flutter/services.dart';
import '../flutter_facebook_auth_platform_interface.dart';
import 'access_token.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'login_behavior.dart';
import 'facebook_auth_exception.dart';

/// class to make calls to the facebook login SDK
class FacebookAuth extends FacebookAuthPlatform {
  final MethodChannel _channel = MethodChannel('app.meedu/flutter_facebook_auth');

  /// make a login request using the facebook SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  ///
  /// [loginBehavior] (only Android) use this param to set the UI for the authentication,
  /// like webview, native app, or a dialog.
  @override
  Future<AccessToken> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) async {
    try {
      final result = await _channel.invokeMethod("login", {
        "permissions": permissions,
        "loginBehavior": loginBehavior,
      });
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      throw FacebookAuthException(e.code, e.message);
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
  Future<AccessToken> expressLogin() async {
    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod("expressLogin");
        return AccessToken.fromJson(Map<String, dynamic>.from(result));
      } on PlatformException catch (e) {
        throw FacebookAuthException(e.code, e.message);
      }
    }
    return null;
  }

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    try {
      final result = await _channel.invokeMethod("getUserData", {
        "fields": fields,
      });
      if (kIsWeb) {
        return Map<String, dynamic>.from(result);
      } else {
        return Platform.isAndroid ? jsonDecode(result) : Map<String, dynamic>.from(result); //null  or dynamic data
      }
    } on PlatformException catch (e) {
      throw FacebookAuthException(e.code, e.message);
    }
  }

  /// Sign Out from Facebook
  @override
  Future<void> logOut() async {
    await _channel.invokeMethod("logOut");
  }

  /// if the user is logged return one instance of AccessToken
  @override
  Future<AccessToken> get isLogged async {
    final result = await _channel.invokeMethod("isLogged");
    if (result != null) {
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    }
    return null;
  }
}
