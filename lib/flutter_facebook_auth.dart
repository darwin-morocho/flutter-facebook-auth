import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class LonginResult {
  static const success = 200;
  static const cancelled = 403;
}

class FacebookAuth {


  static const MethodChannel _channel =
      const MethodChannel('flutter_facebook_auth');

  /// [permissions] permissions like ["email","public_profile"]
  Future<dynamic> login(
      {List<String> permissions = const ['email', 'public_profile']}) async {
    final result =
        await _channel.invokeMethod("login", {"permissions": permissions});

    return result; // accessToken
  }

  /// [fields] string of fileds like birthday,email,hometown
  Future<dynamic> getUserData({String fields = "name,email,picture"}) async {
    print("flutter calling getUserData:");
    final result =
        await _channel.invokeMethod("getUserData", {"fields": fields});
    return jsonDecode(result); //null  or dynamic data
  }

  /// Sign Out
  Future<dynamic> logOut() async {
    await _channel.invokeMethod("logOut");
  }

  /// ig the user is logged return one accessToken
  Future<dynamic> isLogged() async {
    final accessToken = await _channel.invokeMethod("isLogged");
    print(accessToken);
    return accessToken;
  }
}
