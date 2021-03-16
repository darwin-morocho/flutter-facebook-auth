import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:js/js_util.dart';
import 'facebook_auth_interop.dart';

class Auth {
  final FbInterface _fb;
  Auth([FbInterface? fb]) : _fb = fb ?? FB();

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

  Future<Map<String, dynamic>> _getResponse(Object promise) async {
    final jsData = await promiseToFuture(promise);
    return jsonDecode(jsData);
  }

  /// make a login request using the facebook javascript SDK
  ///
  /// [permissions] permissions like ["email","public_profile"]
  Future<Map<String, dynamic>> login(List<String> permissions) async {
    var scope = '';
    permissions.forEach((e) {
      scope += "$e,";
    });
    scope = scope.substring(0, scope.length - 1);

    late Map<String, dynamic> response;
    if (_fb is FB) {
      final promise = _fb.login(scope);
      response = await _getResponse(promise);
    } else {
      response = _fb.login(scope);
    }

    final status = response['status'];
    switch (status) {
      case "connected":
        final data = response['accessToken'];
        final accessToken = _getAccessToken(data);
        return accessToken;

      case "unknown":
        throw PlatformException(code: "CANCELLED", message: "User has cancelled login with facebook");

      default:
        throw PlatformException(code: "FAILED", message: "Facebook login failed");
    }
  }

  /// check if a user is logged and return an accessToken data
  Future<Map<String, dynamic>> getAccessToken() async {
    late Map<String, dynamic> response;
    if (_fb is FB) {
      final promise = _fb.getAccessToken();
      response = await _getResponse(promise);
    } else {
      response = _fb.getAccessToken();
    }

    final status = response['status'];
    switch (status) {
      case "connected":
        final data = response['accessToken'];
        final accessToken = _getAccessToken(data);
        return accessToken;

      default:
        throw PlatformException(code: "FAILED", message: "Facebook login status check failed");
    }
  }

  /// get the user profile information
  ///
  /// [fields] string of fields like birthday,email,hometown
  Future<Map<String, dynamic>> getUserData(String fields) async {
    late Map<String, dynamic> response;
    if (_fb is FB) {
      final promise = _fb.getUserData(fields);
      response = await _getResponse(promise);
    } else {
      response = Map<String, dynamic>.from(_fb.getUserData(fields));
    }
    return response;
  }

  /// close the current active session
  Future<void> logOut() async {
    if (_fb is FB) {
      final promise = _fb.logOut();
      await promiseToFuture(promise);
    } else {
      _fb.logOut();
    }
  }
}
