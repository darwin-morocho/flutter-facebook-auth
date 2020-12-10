import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
export 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
export 'package:flutter_facebook_auth_web/flutter_facebook_auth_web.dart';

/// Generic class that extends of FacebookAuthPlatform interface
class FacebookAuth extends FacebookAuthPlatform {
  FacebookAuth._internal(); // private constructor for singletons
  static FacebookAuth _instance = FacebookAuth._internal();

  /// return the same instance of FacebookAuth
  static FacebookAuth get instance => _instance;

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
  }) {
    return FacebookAuthPlatform.instance.login(
      permissions: permissions,
      loginBehavior: loginBehavior,
    );
  }

  /// Express login logs people in with their Facebook account across devices and platform.
  /// If a person logs into your app on Android and then changes devices,
  /// express login logs them in with their Facebook account, instead of asking for them to select a login method.
  ///
  /// This avoid creating duplicate accounts or failing to log in at all. To support the changes in Android 11,
  /// first add the following code to the queries element in your /app/manifest/AndroidManifest.xml file.
  /// For more info go to https://developers.facebook.com/docs/facebook-login/android
  @override
  Future<AccessToken> expressLogin() {
    return FacebookAuthPlatform.instance.expressLogin();
  }

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) {
    return FacebookAuthPlatform.instance.getUserData(fields: fields);
  }

  /// if the user is logged return one instance of AccessToken
  @override
  Future<AccessToken> get isLogged => FacebookAuthPlatform.instance.isLogged;

  /// Sign Out from Facebook
  @override
  Future<void> logOut() {
    return FacebookAuthPlatform.instance.logOut();
  }
}
