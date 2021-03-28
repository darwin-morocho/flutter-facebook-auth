import 'dart:async';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the FlutterFacebookAuth plugin.
class FlutterFacebookAuthPlugin extends FacebookAuthPlatform {
  final Auth _auth;

  FlutterFacebookAuthPlugin([Auth? auth]) : _auth = auth ?? Auth();

  static void registerWith(Registrar registrar) {
    FacebookAuthPlatform.instance = FlutterFacebookAuthPlugin();
  }

  /// calls the FB.getLoginStatus interop
  @override
  Future<AccessToken?> get accessToken async {
    final result = await _auth.getAccessToken();
    return result.accessToken;
  }

  /// express login is only available on Android
  @override
  Future<LoginResult> expressLogin() {
    throw UnimplementedError();
  }

  /// calls the FB.api interop
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) =>
      _auth.getUserData(fields);

  /// calls the FB.logout interop
  @override
  Future<void> logOut() {
    return _auth.logOut();
  }

  /// calls the FB.login interop
  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) {
    return _auth.login(permissions);
  }

  /// calls the FB.init interop
  @override
  void webInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) {
    _auth.initialize(
      appId: appId,
      cookie: cookie,
      xfbml: xfbml,
      version: version,
    );
  }
}
