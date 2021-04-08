import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:js/js.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'interop/facebook_auth_interop.dart' as fb;
import 'interop/convert_interop.dart';
import 'package:meta/meta.dart' show required;

/// A web implementation of the FlutterFacebookAuth plugin.
class FlutterFacebookAuthPlugin extends FacebookAuthPlatform {
  String _appId = ''; // applicationId

  static void registerWith(Registrar registrar) {
    FacebookAuthPlatform.instance = FlutterFacebookAuthPlugin();
  }

  /// calls the FB.getLoginStatus interop
  ///
  /// check if a user is logged and return an accessToken data
  @override
  Future<AccessToken> get accessToken async {
    Completer<LoginResult> completer = Completer();
    fb.getLoginStatus(
      allowInterop(
        (jsResponse) {
          this._handleResponse(jsResponse).then(
                (result) => completer.complete(result),
              );
        },
      ),
    );
    final LoginResult result = await completer.future;
    return result.accessToken;
  }

  /// express login is only available on Android
  @override
  Future<LoginResult> expressLogin() {
    throw UnimplementedError();
  }

  /// get the user profile information
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
  ///      "is_silhouette": true,
  ///      "url": "https://scontent.fuio21-1.fna.fbcdn.net/v/t1.30497-1/s200x200/84628273_176159830277856_972693363922829312_n.jpg",
  ///      "width": 200
  ///    }
  ///  },
  ///  "id": "136742241592917"
  ///}
  ///```
  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) {
    Completer<Map<String, dynamic>> c = Completer();
    fb.api(
      "/me?fields=$fields",
      allowInterop(
        (_) => c.complete(
          Map<String, dynamic>.from(
            convert(_),
          ),
        ),
      ),
    );
    return c.future;
  }

  /// calls the FB.logout interop
  @override
  Future<void> logOut() {
    Completer<void> c = Completer();
    fb.logout(allowInterop(
      (_) {
        if (!c.isCompleted) {
          c.complete();
        }
      },
    ));
    return c.future;
  }

  /// calls the FB.login interop
  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) {
    String scope = permissions.join(",");
    Completer<LoginResult> completer = Completer();
    fb.login(
      allowInterop(
        (jsResponse) {
          this._handleResponse(jsResponse).then(
                (result) => completer.complete(result),
              );
        },
      ),
      fb.LoginOptions(
        scope: scope,
        return_scopes: true,
      ),
    );

    return completer.future;
  }

  /// initialiaze the facebook javascript SDK
  ///
  /// calls the FB.init interop
  @override
  void webInitialize({
    @required String appId,
    @required bool cookie,
    @required bool xfbml,
    @required String version,
  }) {
    this._appId = appId;
    fb.init(
      fb.InitOptions(
        appId: appId,
        version: version,
        cookie: cookie,
        xfbml: xfbml,
      ),
    );
  }

  /// get the granted and declined permission for the current facebook session
  ///
  /// The facebook SDK will return a JSON like
  /// ```
  /// {
  ///  'data': [
  ///    {
  ///      "permission": "email",
  ///      "status": "granted",
  ///    },
  ///    {
  ///      "permission": "photos",
  ///      "status": "declined",
  ///    }
  ///  ],
  ///}
  /// ```
  @override
  Future<FacebookPermissions> get permissions {
    Completer<FacebookPermissions> c = Completer();
    fb.api(
      "/me/permissions",
      allowInterop(
        (_) {
          try {
            List<String> granted = [];
            List<String> declined = [];
            final response = convert(_);
            _checkResponseError(response);
            for (final item in response['data'] as List) {
              final String permission = item['permission'];
              if (item['status'] == 'granted') {
                granted.add(permission);
              } else {
                declined.add(permission);
              }
            }
            c.complete(
              FacebookPermissions(granted: granted, declined: declined),
            );
          } on PlatformException catch (e) {
            print(
              StackTrace.fromString(e.message ?? 'unknown error'),
            );
            c.complete(null);
          }
        },
      ),
    );
    return c.future;
  }

  /// handle the login or getLoginStatus response
  ///
  /// this method convert the javascript response a valid dart Map and the status
  /// is equals to connected the login or getLoginStatus was success
  ///
  ///
  /// The facebook SDK will return a JSON like
  /// ```
  /// {
  ///   status:"connected",
  ///   authResponse:{
  ///     "userId": "136742241592917",
  ///     "token": "3jNDpzq2L78XUkdYNuMJgzo1WVUa4Cc7z2M029srT",
  ///     "data_access_expiration_time": 1610201170749,
  ///     "graphDomain": "facebook",
  ///     "isExpired": false,
  ///   }
  /// }
  /// ```
  Future<LoginResult> _handleResponse(dynamic _) async {
    try {
      final Map<String, dynamic> response = convert(_);
      _checkResponseError(response);
      final String status = response['status'];

      if (status == null) {
        return LoginResult(status: LoginStatus.failed);
      }
      if (status == 'connected') {
        final Map<String, dynamic> authResponse = response['authResponse'];

        final expires = DateTime.now().add(
          Duration(seconds: authResponse['data_access_expiration_time']),
        );

        // create a Login Result with an accessToken
        return LoginResult(
          status: LoginStatus.success,
          accessToken: AccessToken(
            applicationId: this._appId,
            grantedPermissions:
                null, // on web we don't have this data in the login response
            declinedPermissions:
                null, // on web we don't have this data in the login response
            userId: authResponse['userID'],
            expires: expires,
            lastRefresh: DateTime.now(),
            token: authResponse['accessToken'],
            isExpired: false,
            graphDomain: authResponse['graphDomain'],
          ),
        );
      } else if (status == 'unknown') {
        return LoginResult(status: LoginStatus.cancelled);
      }
      return LoginResult(status: LoginStatus.failed, message: 'unknown error');
    } on PlatformException catch (e) {
      return LoginResult(status: LoginStatus.failed, message: e.message);
    }
  }

  /// check if the response has an error
  void _checkResponseError(Map<String, dynamic> response) {
    if (response['error'] != null) {
      throw PlatformException(
          code: "REQUEST_ERROR", message: response['error']['message']);
    }
  }
}
