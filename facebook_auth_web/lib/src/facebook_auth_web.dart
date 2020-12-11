// ignore: missing_js_lib_annotation
@JS()
library facebook_auth.js;

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

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
      "token": data['token'],
      "userId": data['userId'],
      "expires": DateTime.now()
          .add(
            Duration(seconds: data['data_access_expiration_time']),
          )
          .millisecondsSinceEpoch,
      "applicationId": data['applicationId'],
      "lastRefresh": DateTime.now().millisecondsSinceEpoch,
      "isExpired": false,
      "graphDomain": data['graphDomain'],
      "grantedPermissions": data['grantedPermissions'],
      "declinedPermissions": data['declinedPermissions'],
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
    final promise = _auth.login(scope);
    final String jsData = await promiseToFuture(promise);
    final response = jsonDecode(jsData);
    final String status = response['status'];
    switch (status) {
      case "connected":
        final data = response['accessToken'];
        final accessToken = _getAccessToken(data);
        return accessToken;

      case "unknown":
        throw PlatformException(
            code: "CANCELLED",
            message: "User has cancelled login with facebook");

      default:
        throw PlatformException(
            code: "FAILED", message: "Facebook login failed");
    }
  }

  /// check if a user is logged and return an accessToken data
  Future<Map<String, dynamic>> isLogged() async {
    final promise = _auth.isLogged();
    final String jsData = await promiseToFuture(promise);
    final response = jsonDecode(jsData);
    final String status = response['status'];
    switch (status) {
      case "connected":
        final data = response['accessToken'];
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
    final promise = _auth.getUserData(fields);
    final String response = await promiseToFuture(promise);
    return jsonDecode(response);
  }

  /// close the current active session
  Future<void> logOut() async {
    final promise = _auth.logout();
    await promiseToFuture(promise);
  }
}
