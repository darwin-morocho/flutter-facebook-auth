import 'dart:async';
import 'package:meta/meta.dart' show required;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'src/access_token.dart';
import 'src/login_result.dart';
export 'src/login_result.dart';
export 'src/access_token.dart';

class FacebookAuthLoginResponse {
  static const ok = 200;
  static const cancelled = 403;
  static const error = 500;
}

class FacebookAuth {
  FacebookAuth._internal(); // private constructor for singletons
  final MethodChannel _channel = MethodChannel('ec.dina/flutter_facebook_auth');
  static FacebookAuth _instance = FacebookAuth._internal();
  static FacebookAuth get instance => _instance;

  /// [permissions] permissions like ["email","public_profile"]
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
  }) async {
    final result =
        await _channel.invokeMethod("login", {"permissions": permissions});

    return LoginResult.fromJson(
      Map<String, dynamic>.from(result),
    ); // accessToken
  }

  /// [fields] string of fileds like birthday,email,hometown
  Future<dynamic> getUserData({String fields = "name,email,picture"}) async {
    final result =
        await _channel.invokeMethod("getUserData", {"fields": fields});
    return Platform.isAndroid
        ? jsonDecode(result)
        : Map<String, dynamic>.from(result); //null  or dynamic data
  }

  /// Sign Out
  Future<dynamic> logOut() async {
    await _channel.invokeMethod("logOut");
  }

  /// if the user is logged return one instance of AccessToken
  Future<AccessToken> get isLogged async {
    final result = await _channel.invokeMethod("isLogged");
    if (result != null) {
      return AccessToken.fromJson(Map<String, dynamic>.from(result));
    }
    return null;
  }

  /// check what permisions was granted or declined while login process
  Future<FacebookAuthPermissions> permissions(String token) async {
    final url = "https://graph.facebook.com/me/permissions?access_token=$token";

    final res = await http.get(url);
    final parsed = jsonDecode(res.body);

    List<String> granted = [];
    List<String> declined = [];

    if (res.statusCode == 200) {
      for (final item in parsed['data'] as List) {
        final String permission = item['permission'];
        final String status = item['status'];
        if (status == 'granted') {
          granted.add(permission);
        } else {
          declined.add(permission);
        }
      }
      return FacebookAuthPermissions(granted: granted, declined: declined);
    }
    throw new PlatformException(
        code: "500", message: parsed['error']['message']);
  }
}

class FacebookAuthPermissions {
  final List<String> granted, declined;

  FacebookAuthPermissions({@required this.granted, @required this.declined});
}
