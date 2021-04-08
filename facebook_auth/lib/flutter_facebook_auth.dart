// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:meta/meta.dart' show required;
export 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';

/// Generic class that extends of FacebookAuthPlatform interface
class FacebookAuth implements FacebookAuthPlatform {
  FacebookAuth._internal(); // private constructor for singletons
  static FacebookAuth _instance = FacebookAuth._internal();

  /// return the same instance of FacebookAuth
  static FacebookAuth get instance => _instance;

  FacebookAuthPlatform _ = FacebookAuthPlatform.instance;

  /// if the user is logged return one instance of AccessToken
  @override
  Future<AccessToken> get accessToken => _.accessToken;

  /// Express login logs people in with their Facebook account across devices and platform.
  /// If a person logs into your app on Android and then changes devices,
  /// express login logs them in with their Facebook account, instead of asking for them to select a login method.
  ///
  /// This avoid creating duplicate accounts or failing to log in at all. To support the changes in Android 11,
  /// first add the following code to the queries element in your /app/manifest/AndroidManifest.xml file.
  /// For more info go to https://developers.facebook.com/docs/facebook-login/android
  @override
  Future<LoginResult> expressLogin() => _.expressLogin();

  /// retrive the user information using the GraphAPI
  ///
  /// [fields] string of fields like birthday,email,hometown
  ///
  /// The facebook SDK will return a JSON like
  /// ```
  /// {
  ///  "name": "Open Graph Test User",
  ///  "email": "open_jygexjs_user@tfbnw.net",
  ///  "picture": {
  ///    "data": {
  ///      "height": 126,
  ///      "url": "https://scontent.fuio21-1.fna.fbcdn.net/v/t1.30497-1/s200x200/84628273_176159830277856_972693363922829312_n.jpg",
  ///      "width": 200
  ///    }
  ///  },
  ///  "id": "136742241592917"
  ///}
  ///```
  ///
  ///The above JSON could be change, it depends of your [fields] argument.
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) =>
      _.getUserData(fields: fields);

  /// Sign Out from Facebook
  @override
  Future<void> logOut() => _.logOut();

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
  }) =>
      _.login(permissions: permissions, loginBehavior: loginBehavior);

  /// call this method (ONLY FOR WEB) to initialize the facebook javascript sdk
  @override
  void webInitialize({
    @required String appId,
    @required bool cookie,
    @required bool xfbml,
    @required String version,
  }) {
    _.webInitialize(
      appId: appId,
      cookie: cookie,
      xfbml: xfbml,
      version: version,
    );
  }

  /// returns one instance of FacebookPermission with the granted and declined permissions
  ///
  /// It could be null if you exceed the request limit
  @override
  Future<FacebookPermissions> get permissions => _.permissions;
}
