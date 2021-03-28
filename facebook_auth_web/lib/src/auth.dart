import 'dart:async';
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

  Future<LoginResult> _handleResponse(dynamic _) async {
    final response = convert(_);
    final String? status = response['status'];
    if (status == null) {
      return LoginResult(status: LoginStatus.failed);
    }
    if (status == 'connected') {
      final authResponse = response['authResponse'];
      final permissions = await _getGrantedAndDeclinedPermissions();
      final expires = DateTime.now()
          .add(
            Duration(seconds: authResponse['data_access_expiration_time']),
          )
          .millisecondsSinceEpoch;

      return LoginResult(
        status: LoginStatus.success,
        accessToken: AccessToken(
          applicationId: Auth.appId,
          grantedPermissions: permissions.granted,
          declinedPermissions: permissions.declined,
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
  }

  Future<_GrantedAndDeclined> _getGrantedAndDeclinedPermissions() {
    Completer<_GrantedAndDeclined> c = Completer();
    fb.api(
      "/me/permissions",
      allowInterop(
        (_) {
          List<String> granted = [];
          List<String> declined = [];
          final response = convert(_);
          for (final item in response['data'] as List) {
            final String permission = item['permission'];
            if (item['status'] == 'granted') {
              granted.add(permission);
            } else {
              declined.add(permission);
            }
          }

          c.complete(
            _GrantedAndDeclined(granted: granted, declined: declined),
          );
        },
      ),
    );
    return c.future;
  }
}

class _GrantedAndDeclined {
  final List<String> granted, declined;
  _GrantedAndDeclined({required this.granted, required this.declined});
}
