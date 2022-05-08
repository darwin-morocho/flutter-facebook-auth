library facebook_auth_desktop;

import 'dart:convert';

import 'package:facebook_auth_desktop/custom_http_client.dart';
import 'package:facebook_desktop_webview_auth/desktop_webview_auth.dart';
import 'package:facebook_desktop_webview_auth/facebook.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _facebookAccessTokenKey = 'facebook-desktop-access-token';

class FlutterFacebookDesktopAuthPlugin extends FacebookAuthPlatform {
  String _appId = '';
  String _version = '';

  late final FlutterSecureStorage _secureStorage;
  late final CustomHttpClient _httpClient;

  static void registerWith() {
    FacebookAuthPlatform.instance = FlutterFacebookDesktopAuthPlugin();
  }

  FlutterFacebookDesktopAuthPlugin({
    FlutterSecureStorage? secureStorage,
    CustomHttpClient? httpClient,
  }) {
    _httpClient = httpClient ?? CustomHttpClient();
    _secureStorage = secureStorage ?? const FlutterSecureStorage();
    FacebookAuthPlatform.instance = this;
  }

  @override
  Future<AccessToken?> get accessToken async {
    final data = await _secureStorage.read(
      key: _facebookAccessTokenKey,
    );
    if (data != null) {
      return AccessToken.fromJson(
        jsonDecode(data),
      );
    }
    return null;
  }

  @override
  Future<void> autoLogAppEventsEnabled(bool enabled) {
    throw UnimplementedError();
  }

  @override
  Future<LoginResult> expressLogin() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    final token = (await accessToken)?.token;
    return {};
  }

  @override
  Future<bool> get isAutoLogAppEventsEnabled => Future.value(false);

  @override
  bool get isWebSdkInitialized => false;

  @override
  Future<void> logOut() {
    return _secureStorage.delete(
      key: _facebookAccessTokenKey,
    );
  }

  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    LoginBehavior loginBehavior = LoginBehavior.dialogOnly,
  }) async {
    assert(
      _appId.isNotEmpty,
      'On desktop before call login() you must call to desktopInitialize(...)',
    );

    final result = await DesktopWebviewAuth.signIn(
      FacebookSignInArgs(
        clientId: _appId,
        version: _version,
        scope: 'email,public_profile',
      ),
    );

    if (result != null) {}

    return LoginResult(status: LoginStatus.cancelled);
  }

  @override
  Future<FacebookPermissions?> get permissions async {
    final savedToken = await accessToken;
    if (savedToken != null) {
      return FacebookPermissions(
        granted: savedToken.grantedPermissions!,
        declined: savedToken.declinedPermissions!,
      );
    }
    return null;
  }

  @override
  Future<void> webAndDesktopInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) async {
    _appId = appId;
    _version = version;
  }
}
