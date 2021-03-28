import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meedu/state.dart';

class SplashController extends SimpleController {
  final FacebookAuth _facebookAuth;
  bool? _isLogged;
  bool _fetching = false;

  bool get fetching => _fetching;
  bool? get isLogged => _isLogged;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  SplashController(this._facebookAuth);

  @override
  void onAfterFirstLayout() {
    _init();
  }

  void _init() async {
    _isLogged = await this._facebookAuth.accessToken != null;
    if (_isLogged!) {
      _userData = await _facebookAuth.getUserData();
    }
    update();
  }

  Future<bool> login() async {
    _fetching = true;
    update(['login-view']);
    final result = await _facebookAuth.login();

    _isLogged = result.status == LoginStatus.success;
    if (_isLogged!) {
      _userData = await _facebookAuth.getUserData();
    }
    _fetching = false;
    update(['login-view']);
    return _isLogged!;
  }

  Future<void> logout() async {
    _fetching = true;
    update(['login-view']);
    await _facebookAuth.logOut();
    _fetching = false;
    _isLogged = false;
    update(['login-view']);
  }
}
