library facebook_auth_desktop;

import 'dart:convert';
import 'dart:math';

import 'package:facebook_auth_desktop/src/custom_http_client.dart';
import 'package:facebook_auth_desktop/src/platform_channel.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _facebookAccessTokenKey = 'facebook-desktop-access-token';

class FacebookAuthDesktopPlugin extends FacebookAuthPlatform {
  String _appId = '';
  String _version = '';

  late final FlutterSecureStorage _secureStorage;
  late final CustomHttpClient _httpClient;

  // coverage:ignore-start
  static void registerWith() {
    FacebookAuthPlatform.instance = FacebookAuthDesktopPlugin();
  }
  // coverage:ignore-end

  FacebookAuthDesktopPlugin({
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
      final accessToken = ClassicToken.fromJson(
        jsonDecode(data),
      );

      if (DateTime.now().isAfter(accessToken.expires)) {
        return null;
      }

      return accessToken;
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
    final token = (await accessToken)?.tokenString;

    final response = await _httpClient.get(
      Uri.parse(
        'https://graph.facebook.com/me?access_token=$token&fields=$fields',
      ),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    return {}; // coverage:ignore-line
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
    LoginTracking loginTracking = LoginTracking.enabled,
    String? nonce,
  }) async {
    assert(
      _appId.isNotEmpty,
      'On desktop before call login() you must call to desktopInitialize(...)',
    );

    final signInURL = Uri.parse(
      'https://www.facebook.com/$_version/dialog/oauth',
    );
    const redirectURL = 'https://www.facebook.com/connect/login_success.html';

    final signInUri = Uri(
      scheme: signInURL.scheme,
      host: signInURL.host,
      path: signInURL.path,
      queryParameters: {
        'client_id': _appId,
        'redirect_uri': redirectURL,
        'response_type': 'token,granted_scopes',
        'scope': permissions.join(','),
        'state': _generateNonce(),
      },
    );

    final callbackUrl = await PlatformChannel().signIn(
      signInUri.toString(),
      redirectURL,
    );

    if (callbackUrl != null) {
      final uri = Uri.parse(callbackUrl);
      final fragment = uri.fragment;
      final arguments = Uri.splitQueryString(fragment);

      final error = uri.queryParameters['error'];
      if (error != null) {
        if (error == 'access_denied') {
          return LoginResult(
            status: LoginStatus.cancelled,
            message: 'Login canceled by user.',
          );
        }

        return LoginResult(
          status: LoginStatus.failed,
          message: 'Login failed.',
        );
      }

      // Facebook reports app configuration problems -- a redirect URI missing
      // from the app's allow list, embedded browser login turned off -- with
      // `error_code`/`error_message` rather than `error`, and sends no token.
      // Without this the flow would fall through to the token handling below
      // and turn a reportable failure into an unhandled exception.
      final errorCode = uri.queryParameters['error_code'];
      if (errorCode != null) {
        return LoginResult(
          status: LoginStatus.failed,
          message: uri.queryParameters['error_message'] ??
              'Login failed with error $errorCode.',
        );
      }

      String? token = arguments['long_lived_token'];
      bool isLoginLiveToken = token != null;

      late final DateTime expiresIn;

      if (!isLoginLiveToken) {
        token = arguments['access_token'];
        if (token == null) {
          return LoginResult(
            status: LoginStatus.failed,
            message: 'Facebook did not return an access token.',
          );
        }
        expiresIn = DateTime.now().add(
          Duration(
            // A token always arrives with its lifetime; fall back to the
            // length of a short-lived token rather than throwing if it does
            // not, since the token itself is still usable.
            seconds: int.tryParse(arguments['expires_in'] ?? '') ?? 3600,
          ),
        );
      } else {
        expiresIn = DateTime.now().add(
          const Duration(days: 59),
        );
      }

      final grantedScopes = arguments['granted_scopes']?.split(',') ?? const [];
      final deniedScopes = arguments['denied_scopes']?.split(',') ?? const [];

      final response = await _httpClient.get(
        Uri.parse('https://graph.facebook.com/me?access_token=$token'),
      );
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        final accessToken = ClassicToken(
          declinedPermissions: deniedScopes,
          grantedPermissions: grantedScopes,
          userId: userData['id'],
          expires: expiresIn,
          tokenString: token,
          applicationId: _appId,
        );

        await _secureStorage.delete(key: _facebookAccessTokenKey);

        await _secureStorage.write(
          key: _facebookAccessTokenKey,
          value: jsonEncode(
            accessToken.toJson(),
          ),
        );

        return LoginResult(
          status: LoginStatus.success,
          accessToken: accessToken,
        );
      }

      return LoginResult(
        status: LoginStatus.failed,
        message: 'User info could not be get it',
      );
    }

    return LoginResult(status: LoginStatus.cancelled);
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

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String _generateNonce([int length = 32]) {
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  final random = Random.secure();

  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}
