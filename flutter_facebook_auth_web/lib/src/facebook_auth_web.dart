// ignore: missing_js_lib_annotation
@JS()
library facebook_auth.js;

// ignore: unused_import
import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/services.dart';
import 'package:js/js.dart';

@JS('FacebookAuth')
class FacebookAuth {
  external FacebookAuth();
  external login(String scope);
  external isLogged();
  external getUserData(String fields);
  external logout();
}

class FacebookAuthWeb {
  final _auth = FacebookAuth();

  /// parse the web response to a Map
  Map<String, dynamic> _getAccessToken(dynamic data) {
    return {
      "token": data.token,
      "userId": data.userId,
      "expires": DateTime.now()
          .add(
            Duration(seconds: data.data_access_expiration_time),
          )
          .millisecondsSinceEpoch,
      "applicationId": data.applicationId,
      "lastRefresh": DateTime.now().millisecondsSinceEpoch,
      "isExpired": false,
      "graphDomain": data.graphDomain,
      "grantedPermissions": data.grantedPermissions,
      "declinedPermissions": data.declinedPermissions,
    };
  }

  /// make a login request using the facebook javascript SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  Future<Map<String, dynamic>> login(List<String> permissions) async {
    String scope = '';
    permissions.forEach((e) {
      scope += "$e,";
    });
    scope = scope.substring(0, scope.length - 1);
    final promise = await _auth.login(scope);
    final response = await promiseToFuture(promise);
    final String status = response.status;
    switch (status) {
      case "connected":
        final data = response.accessToken;
        final accessToken = _getAccessToken(data);
        print("accessToken::: $accessToken ");
        return accessToken;

      case "unknown":
        throw PlatformException(
            code: "CANCELLED",
            message: "User has cancelled login with facebook");

      default:
        throw PlatformException(
            code: "FAILED", message: "Facebook we login failed");
    }
  }

  /// check if a user is logged and return an accessToken data
  Future<Map<String, dynamic>> isLogged() async {
    final promise = await _auth.isLogged();
    final response = await promiseToFuture(promise);
    final String status = response.status;
    switch (status) {
      case "connected":
        final data = response.accessToken;
        final accessToken = _getAccessToken(data);
        return accessToken;

      default:
        return null;
    }
  }

  /// get the user profile information
  ///
  /// [fields] string of fields like birthday,email,hometown
  Future<Map<String, dynamic>> getUserData(String fields) async {
    final promise = await _auth.getUserData(fields);
    final response = await promiseToFuture(promise);
    return json.decode(response);
  }

  /// close the current active session
  Future<void> logOut() async {
    final promise = await _auth.logout();
    await promiseToFuture(promise);
  }
}
