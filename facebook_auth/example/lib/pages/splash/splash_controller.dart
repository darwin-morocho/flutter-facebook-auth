import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class SplashController extends ChangeNotifier {
  final FacebookAuth _facebookAuth;
  bool _isLogged;
  bool _fetching = false;

  bool get fetching => _fetching;
  bool get isLogged => _isLogged;

  Map<String, dynamic> _userData;
  Map<String, dynamic> get userData => _userData;

  SplashController(this._facebookAuth) {
    _init();
  }

  void _init() async {
    _isLogged = await this._facebookAuth.accessToken != null;
    if (_isLogged) {
      _userData = await _facebookAuth.getUserData();
    }
    notifyListeners();
  }

  Future<bool> login() async {
    _fetching = true;
    notifyListeners();
    final result = await _facebookAuth.login(
      permissions: ['email', 'public_profile', 'user_birthday'],
    );

    _isLogged = result.status == LoginStatus.success;
    if (_isLogged) {
      _userData = await _facebookAuth.getUserData(fields: "name,email,picture.width(200),birthday");
      print(prettyPrint(_userData));
    }
    _fetching = false;
    notifyListeners();
    return _isLogged;
  }

  Future<void> logout() async {
    _fetching = true;
    notifyListeners();
    await _facebookAuth.logOut();
    _fetching = false;
    _isLogged = false;
    notifyListeners();
  }
}
