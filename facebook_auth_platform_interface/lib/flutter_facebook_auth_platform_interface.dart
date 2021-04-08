import 'package:flutter_facebook_auth_platform_interface/src/facebook_permissions.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:meta/meta.dart' show required;
import 'src/login_result.dart';
import 'src/access_token.dart';
import 'src/method_cahnnel.dart';
import 'src/login_behavior.dart';
export 'src/access_token.dart';
export 'src/login_behavior.dart';
export 'src/facebook_auth_error_code.dart';
export 'src/method_cahnnel.dart';
export 'src/login_result.dart';
export 'src/facebook_permissions.dart';

/// The interface that implementations of flutter_facebook_auth must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_facebook_auth`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FacebookAuthPlatform] methods.
abstract class FacebookAuthPlatform extends PlatformInterface {
  static const _token = Object();
  FacebookAuthPlatform() : super(token: _token);

  static FacebookAuthPlatform _instance = MethodCahnnelFacebookAuth();

  // ignore: unnecessary_getters_setters
  static FacebookAuthPlatform get instance => _instance;

  // ignore: unnecessary_getters_setters
  static set instance(FacebookAuthPlatform i) {
    _instance = i;
  }

  /// initialiaze the facebook javascript sdk
  void webInitialize({
    @required String appId,
    @required bool cookie,
    @required bool xfbml,
    @required String version,
  });

  /// make a login request using the facebook SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  ///
  /// [loginBehavior] (only Android) use this param to set the UI for the authentication,
  /// like webview, native app, or a dialog.
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  });

  /// Express login logs people in with their Facebook account across devices and platform.
  /// If a person logs into your app on Android and then changes devices,
  /// express login logs them in with their Facebook account, instead of asking for them to select a login method.
  ///
  /// This avoid creating duplicate accounts or failing to log in at all. To support the changes in Android 11,
  /// first add the following code to the queries element in your /app/manifest/AndroidManifest.xml file.
  /// For more info go to https://developers.facebook.com/docs/facebook-login/android
  Future<LoginResult> expressLogin();

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  });

  /// Sign Out from Facebook
  Future<void> logOut();

  /// if the user is logged return one instance of AccessToken
  Future<AccessToken> get accessToken;

  /// get the permissions for the current access token
  Future<FacebookPermissions> get permissions;
}
