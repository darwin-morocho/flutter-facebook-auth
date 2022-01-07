import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  });

  group('authentication failed', () {
    const MethodChannel channel = MethodChannel(
      'app.meedu/flutter_facebook_auth',
    );

    late FacebookAuthPlatform facebookAuth;

    setUp(() {
      facebookAuth = FacebookAuthPlatform.getInstance();
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
      expect(facebookAuth.isWebSdkInitialized, false);
      final result = await facebookAuth.login();
      expect(result.status, LoginStatus.failed);
    });

    test('express login failed', () async {
      final result = await facebookAuth.expressLogin();
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
    late bool isLogged, isAutoLogAppEventsEnabled;
    late FacebookAuthPlatform facebookAuth;

    setUp(() {
      isLogged = false;
      isAutoLogAppEventsEnabled = false;
      facebookAuth = FacebookAuthPlatform.getInstance();
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
            final isAndroid = defaultTargetPlatform == TargetPlatform.android;
            final result = isLogged ? MockData.userData : {};

            return isAndroid ? jsonEncode(result) : result;

          case "isAutoLogAppEventsEnabled":
            return isAutoLogAppEventsEnabled;

          case "updateAutoLogAppEventsEnabled":
            final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
            if (isIOS) {
              isAutoLogAppEventsEnabled = call.arguments['enabled'];
            }
        }
      });
    });

    test('authenticated', () async {
      AccessToken? accessToken = await facebookAuth.accessToken;
      Map<String, dynamic> userData = await facebookAuth.getUserData();
      expect(accessToken, null);
      expect(userData.length == 0, true);
      final loginResult = await facebookAuth.login(loginBehavior: LoginBehavior.nativeWithFallback);
      if (loginResult.status == LoginStatus.success) {
        accessToken = loginResult.accessToken;
        expect(accessToken, isNotNull);
        final accessTokenAsJson = accessToken!.toJson();
        expect(accessTokenAsJson.containsKey('token'), true);
        expect(await facebookAuth.accessToken, isA<AccessToken>());
        expect((await facebookAuth.expressLogin()), isA<LoginResult>());
        userData = await facebookAuth.getUserData();
        expect(userData.containsKey("email"), true);
        await facebookAuth.logOut();
        expect(await facebookAuth.accessToken, null);
      }
    });

    test('permissions test', () async {
      await facebookAuth.login(loginBehavior: LoginBehavior.deviceAuth);
      final grantedPermissions = (await facebookAuth.permissions)!.granted;
      expect(grantedPermissions.contains("email"), true);
      expect(grantedPermissions.contains("user_link"), true);
    });

    test('express login sucess', () async {
      final loginResult = await facebookAuth.expressLogin();
      expect(loginResult.status == LoginStatus.success, true);
    });

    test('express login failed', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      facebookAuth.webInitialize(appId: "1233443", cookie: true, xfbml: true, version: "v9.0");
      final loginResult = await facebookAuth.expressLogin();
      print("loginResult.status ${loginResult.status}");
      expect(loginResult.status == LoginStatus.failed, true);
    });

    test('autoLogAppEventsEnabled', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(await facebookAuth.isAutoLogAppEventsEnabled, false);
      await facebookAuth.autoLogAppEventsEnabled(true);
      expect(await facebookAuth.isAutoLogAppEventsEnabled, true);
    });

    test('set instance', () {
      FacebookAuthPlatform.instance = MockFacebookAuthPlatform();
      expect(FacebookAuthPlatform.instance, isA<MockFacebookAuthPlatform>());
    });
  });
}

class MockFacebookAuthPlatform extends FacebookAuthPlatform with Mock {}
