library flutter_facebook_auth_platform_interface;

import 'src/access_token.dart';
import 'src/login_behavior.dart';
import 'src/method_channel_facebook_auth.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/access_token.dart';
export 'src/method_channel_facebook_auth.dart';
export 'src/login_behavior.dart';
export 'src/facebook_auth_error_code.dart';
export 'src/facebook_auth_exception.dart';

abstract class FacebookAuthPlatform extends PlatformInterface {
  static FacebookAuthPlatform _instance = FacebookAuth();
  static FacebookAuth get instance => _instance; // return the same instance of FacebookAuthPlatform

  /// make a login request using the facebook SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  ///
  /// [loginBehavior] (only Android) use this param to set the UI for the authentication,
  /// like webview, native app, or a dialog.
  Future<AccessToken> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) async {
    throw UnimplementedError('login() has not been implemented.');
  }

  /// Express login logs people in with their Facebook account across devices and platform.
  /// If a person logs into your app on Android and then changes devices,
  /// express login logs them in with their Facebook account, instead of asking for them to select a login method.
  ///
  /// This avoid creating duplicate accounts or failing to log in at all. To support the changes in Android 11,
  /// first add the following code to the queries element in your /app/manifest/AndroidManifest.xml file.
  /// For more info go to https://developers.facebook.com/docs/facebook-login/android
  Future<AccessToken> expressLogin() async {
    throw UnimplementedError('expressLogin() has not been implemented.');
  }

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    throw UnimplementedError('getUserData() has not been implemented.');
  }

  /// Sign Out from Facebook
  Future<void> logOut() async {
    throw UnimplementedError('logOut() has not been implemented.');
  }

  /// if the user is logged return one instance of AccessToken
  Future<AccessToken> get isLogged async {
    throw UnimplementedError('isLogged has not been implemented.');
  }
}
