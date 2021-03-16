import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_facebook_auth_web/src/interop/auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the FlutterFacebookAuth plugin.
class FacebookAuthPlugin extends FacebookAuthPlatform {
  final Auth _auth;

  FacebookAuthPlugin([Auth? auth]) : _auth = auth ?? Auth();

  static void registerWith(Registrar registrar) {
    FacebookAuthPlatform.instance = FacebookAuthPlugin();
  }

  @override
  Future<AccessToken?> get accessToken async {
    try {
      final result = await _auth.getAccessToken();
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AccessToken?> expressLogin() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) =>
      _auth.getUserData(fields);

  @override
  Future<void> logOut() {
    return _auth.logOut();
  }

  @override
  Future<AccessToken> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) async {
    try {
      final result = await _auth.login(permissions);
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      throw FacebookAuthException(e.code, e.message);
    }
  }
}
