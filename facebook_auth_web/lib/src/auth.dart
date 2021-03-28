import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';

import 'package:js/js.dart';
import 'interop/convert_interop.dart';
import 'interop/facebook_auth_interop.dart' as fb;

class Auth {
  static String appId = '';

  /// initialiaze the facebook javascript SDK
  void initialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) {
    Auth.appId = appId;
    fb.init(
      fb.InitOptions(
        appId: appId,
        version: version,
        cookie: cookie,
        xfbml: xfbml,
      ),
    );
  }

  /// make a login request using the facebook javascript SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  Future<LoginResult> login(List<String> permissions) {
    String scope = '';
    permissions.forEach((e) {
      scope += "$e,";
    });
    scope = scope.substring(0, scope.length - 1);

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

  /// check if a user is logged and return an accessToken data
  Future<LoginResult> getAccessToken() async {
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
    return completer.future;
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
  Future<Map<String, dynamic>> getUserData(String fields) {
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

  /// close the current active session
  Future<void> logOut() async {
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
      final String? status = response['status'];
      if (status == null) {
        return LoginResult(status: LoginStatus.failed);
      }
      if (status == 'connected') {
        final Map<String, dynamic> authResponse = response['authResponse'];

        final expires = DateTime.now()
            .add(
              Duration(seconds: authResponse['data_access_expiration_time']),
            )
            .millisecondsSinceEpoch;

        // create a Login Result with an accessToken
        return LoginResult(
          status: LoginStatus.success,
          accessToken: AccessToken(
            applicationId: Auth.appId,
            grantedPermissions:
                null, // on web we don't have this data in the login response
            declinedPermissions:
                null, // on web we don't have this data in the login response
            userId: authResponse['userID'],
            expires: DateTime.fromMillisecondsSinceEpoch(expires),
            lastRefresh: DateTime.now(),
            token: authResponse['accessToken'],
            isExpired: false,
            graphDomain: authResponse['graphDomain'],
          ),
        );
      } else if (status == 'unknown') {
        return LoginResult(status: LoginStatus.cancelled);
      }
      return LoginResult(status: LoginStatus.failed);
    } catch (e) {
      if (e is PlatformException) {
        return LoginResult(status: LoginStatus.failed, message: e.message);
      }
      return LoginResult(status: LoginStatus.failed, message: "unknown error");
    }
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
  Future<FacebookPermissions> getGrantedAndDeclinedPermissions() {
    Completer<FacebookPermissions> c = Completer();
    fb.api(
      "/me/permissions",
      allowInterop(
        (_) {
          List<String> granted = [];
          List<String> declined = [];
          final response = convert(_);
          if (response['error'] != null) {
            throw PlatformException(
                code: "REQUEST_LIMIT", message: response['error']['message']);
          }

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
        },
      ),
    );
    return c.future;
  }
}
