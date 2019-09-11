import 'dart:async';

import 'package:flutter/services.dart';

class FacebookAuth {
  static const MethodChannel _channel =
      const MethodChannel('flutter_facebook_auth');

  /// [permissions] permissions like ["email","public_profile"]
  static Future<dynamic> login(
      {List<String> permissions = const ['email', 'public_profile']}) async {
    final result =
        await _channel.invokeMethod("login", {"permissions": permissions});

    return result; // accessToken
  }

  /// [fields] string of fileds like birthday,email,hometown
  static Future<dynamic> getUserData(
      {String fields = "name,email,picture"}) async {
    print("flutter calling getUserData:");
    final result =
        await _channel.invokeMethod("getUserData", {"fields": fields});
    return result; //null  or dynamic data
  }

  /// Sign Out
  static Future<dynamic> logOut() async {
    await _channel.invokeMethod("logOut");
  }

  /// ig the user is logged return one accessToken
  static Future<String> isLogged() async {
    final accessToken = await _channel.invokeMethod("isLogged");
    print(accessToken);
    return accessToken;
  }
}
