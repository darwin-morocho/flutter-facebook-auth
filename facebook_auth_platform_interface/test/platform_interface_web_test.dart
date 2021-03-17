@TestOn('browser')

import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('login ok', () async {
      final instance = FacebookAuthPlatform.instance;
      AccessToken? accessToken = await FacebookAuthPlatform.instance.accessToken;
      Map<String, dynamic> userData = await FacebookAuthPlatform.instance.getUserData();
      expect(accessToken, null);
      expect(userData.length == 0, true);
      accessToken = await instance.login();
      expect(accessToken, isNotNull);
      final accessTokenAsJson = accessToken.toJson();
      expect(accessTokenAsJson.containsKey('token'), true);

      userData = await instance.getUserData();
      expect(userData.containsKey("email"), true);
      await instance.logOut();
      expect(await instance.accessToken, null);
    });
  });
}
