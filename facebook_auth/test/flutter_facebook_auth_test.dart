import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'src/data.dart';

bool isLogged = false;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('authentication', () {
    const MethodChannel channel = MethodChannel(
      'app.meedu/flutter_facebook_auth',
    );
    FacebookAuth facebookAuth;
    setUp(() {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "login":
            isLogged = true;
            return MockData.accessToken;
          case "expressLogin":
            isLogged = true;
            return MockData.accessToken;
          case "isLogged":
            return isLogged ? MockData.accessToken : null;
          case "logOut":
            isLogged = false;
            return null;

          case "getUserData":
            final String fields = call.arguments['fields'];
            return (await MockData.getUserData(fields)) ?? PlatformException(code: "FAILED", message: "Failes");
        }
      });
      facebookAuth = FacebookAuth.instance;
    });

    test('login request', () async {
      expect(await facebookAuth.isLogged, null);
      final AccessToken accessToken = await facebookAuth.login();
      expect(accessToken, isNotNull);
      expect(await facebookAuth.isLogged, isA<AccessToken>());
      final Map<String, dynamic> userData = await facebookAuth.getUserData();
      expect(userData.containsKey("email"), true);
      await facebookAuth.logOut();
      expect(await facebookAuth.isLogged, null);
    });

    test('express login', () async {
      expect(await facebookAuth.isLogged, null);
      try {
        await facebookAuth.expressLogin();
      } catch (e) {
        expect(e, isA<FacebookAuthException>());
      }
    });
  });
}
