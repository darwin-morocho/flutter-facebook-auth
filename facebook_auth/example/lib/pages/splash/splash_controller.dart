import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/main.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends ChangeNotifier {
  final FacebookAuth _facebookAuth;
  final Permission _appTrackingTransparencyPermission;
  bool? _isLogged;
  bool _fetching = false;

  bool get fetching => _fetching;
  bool? get isLogged => _isLogged;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  SplashController(
      this._facebookAuth, this._appTrackingTransparencyPermission) {
    _init();
  }

  void _init() async {
    print(
      "isWebSdkInitialized ${this._facebookAuth.isWebSdkInitialized}",
    );
    print(
      "isAutoLogAppEventsEnabled ${await this._facebookAuth.isAutoLogAppEventsEnabled}",
    );
    final accessToken = await this._facebookAuth.accessToken;
    _isLogged = accessToken != null;
    if (_isLogged!) {
      _userData = await _facebookAuth.getUserData(
        fields: "name,email,picture.width(200)",
      );

      print(accessToken!.expires);
      prettyPrint(_userData!);
    }
    notifyListeners();
  }

  Future<bool> login() async {
    _fetching = true;
    notifyListeners();
    final LoginResult result = await _facebookAuth.login();

    _isLogged = result.status == LoginStatus.success;
    if (_isLogged!) {
      _userData = await _facebookAuth.getUserData();
      prettyPrint(_userData!);
    }
    _fetching = false;
    notifyListeners();
    return _isLogged!;
  }

  Future<void> logout() async {
    _fetching = true;
    notifyListeners();
    await _facebookAuth.logOut();
    _fetching = false;
    _isLogged = false;
    notifyListeners();
  }

  Future<void> requestAppTrackingTransparencyPermission() async {
    print("next");
    final status = await _appTrackingTransparencyPermission.request();
    if (status == PermissionStatus.granted) {
      await _facebookAuth.autoLogAppEventsEnabled(true);
      print(
        "isAutoLogAppEventsEnabled:: ${await _facebookAuth.isAutoLogAppEventsEnabled}",
      );
    }
  }
}
