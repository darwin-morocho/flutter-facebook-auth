import 'dart:convert';
import 'package:flutter/services.dart';
import 'login_result.dart';
import '../flutter_facebook_auth_platform_interface.dart';
import 'access_token.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'login_behavior.dart';

/// class to make calls to the facebook login SDK
class MethodCahnnelFacebookAuth extends FacebookAuthPlatform {
  @visibleForTesting
  MethodChannel channel = const MethodChannel('app.meedu/flutter_facebook_auth');

  /// make a login request using the facebook SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  ///
  /// [loginBehavior] (only Android) use this param to set the UI for the authentication,
  /// like webview, native app, or a dialog.
  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) async {
    try {
      final result = await channel.invokeMethod("login", {
        "permissions": permissions,
        "loginBehavior": loginBehavior,
      });
      final token = AccessToken.fromJson(Map<String, dynamic>.from(result));
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
    final tesing = Platform.environment.containsKey('FLUTTER_TEST');
    if (Platform.isAndroid || tesing) {
      try {
        final result = await channel.invokeMethod("expressLogin");
        final token = AccessToken.fromJson(Map<String, dynamic>.from(result));
        return LoginResult(status: LoginStatus.success, accessToken: token);
      } on PlatformException catch (e) {
        return LoginResult.getResultFromException(e);
      }
    }
    return LoginResult(status: LoginStatus.failed, message: 'Method only allowed on Android');
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
    if (kIsWeb) {
      return Map<String, dynamic>.from(result);
    } else {
      return Platform.isAndroid ? jsonDecode(result) : Map<String, dynamic>.from(result); //null  or dynamic data
    }
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
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    }
    return null;
  }

  @override
  void webInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) {}
}
