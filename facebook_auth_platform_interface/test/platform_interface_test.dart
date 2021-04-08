import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_facebook_auth_platform_interface/src/login_result.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('authentication failed', () {
    const MethodChannel channel = MethodChannel(
      'app.meedu/flutter_facebook_auth',
    );

    FacebookAuthPlatform.instance = MethodCahnnelFacebookAuth();

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "login":
            throw PlatformException(code: "FAILED", message: 'failed');
          case "expressLogin":
            throw PlatformException(code: "FAILED", message: 'failed');
          case "getUserData":
            throw PlatformException(code: "FAILED", message: 'failed');
        }
      });
    });

    test('login failed', () async {
      final instance = FacebookAuthPlatform.instance;
      final result = await instance.login();
      expect(result.status, LoginStatus.failed);
    });

    test('express login failed', () async {
      final instance = FacebookAuthPlatform.instance;
      final result = await instance.expressLogin();
      expect(result.status, LoginStatus.failed);
    });
    test('get user date failed', () async {
      try {
        final instance = FacebookAuthPlatform.instance;
        await instance.getUserData();
      } catch (e) {
        expect(e, isA<PlatformException>());
      }
    });
  });

  group('authenticated', () {
    const MethodChannel channel = MethodChannel(
      'app.meedu/flutter_facebook_auth',
    );
    bool isLogged = false;
    setUp(() {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "login":
            isLogged = true;
            return MockData.accessToken;
          case "expressLogin":
            isLogged = true;
            return MockData.accessToken;
          case "getAccessToken":
            return isLogged ? MockData.accessToken : null;
          case "logOut":
            isLogged = false;
            return null;

          case "getUserData":
            return isLogged ? MockData.userData : {};
        }
      });
    });

    test('authenticated', () async {
      final instance = FacebookAuthPlatform.instance;
      AccessToken accessToken = await FacebookAuthPlatform.instance.accessToken;
      Map<String, dynamic> userData = await FacebookAuthPlatform.instance.getUserData();
      expect(accessToken, null);
      expect(userData.length == 0, true);
      final loginResult = await instance.login();
      if (loginResult.status == LoginStatus.success) {
        accessToken = loginResult.accessToken;
        expect(accessToken, isNotNull);
        final accessTokenAsJson = accessToken.toJson();
        expect(accessTokenAsJson.containsKey('token'), true);
        expect(await instance.accessToken, isA<AccessToken>());
        expect((await instance.expressLogin()), isA<LoginResult>());
        userData = await instance.getUserData();
        expect(userData.containsKey("email"), true);
        await instance.logOut();
        expect(await instance.accessToken, null);
      }
    });
  });
}
