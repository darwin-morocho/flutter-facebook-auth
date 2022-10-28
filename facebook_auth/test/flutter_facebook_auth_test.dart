// ignore_for_file: dead_code

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'src/data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final accessToken = AccessToken.fromJson(
    mockAccessToken,
  );
  group('authentication', () {
    late FacebookAuth facebookAuth;

    setUp(
      () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        facebookAuth = MockFacebookAuth();
        when(
          () => facebookAuth.webAndDesktopInitialize(
            appId: any(named: 'appId'),
            cookie: any(named: 'cookie'),
            xfbml: any(named: 'xfbml'),
            version: any(named: 'version'),
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );

        when(
          () => facebookAuth.getUserData(),
        ).thenAnswer(
          (_) => Future.value(
            mockUserData,
          ),
        );

        when(
          () => facebookAuth.permissions,
        ).thenAnswer(
          (_) async {
            return FacebookPermissions(
              granted: [
                ...?accessToken.grantedPermissions,
              ],
              declined: [
                ...?accessToken.declinedPermissions,
              ],
            );
          },
        );
      },
    );

    test('login request', () async {
      bool logged = false;
      when(
        () => facebookAuth.isWebSdkInitialized,
      ).thenReturn(false);

      when(
        () => facebookAuth.accessToken,
      ).thenAnswer(
        (_) async => logged ? accessToken : null,
      );

      when(
        () => facebookAuth.login(),
      ).thenAnswer(
        (_) async {
          logged = true;
          return LoginResult(
            status: LoginStatus.success,
            accessToken: accessToken,
          );
        },
      );

      when(
        () => facebookAuth.logOut(),
      ).thenAnswer(
        (_) async {
          logged = false;
          return Future.value();
        },
      );

      expect(facebookAuth.isWebSdkInitialized, false);
      expect(await facebookAuth.accessToken, null);
      await facebookAuth.webAndDesktopInitialize(
        appId: "1233443",
        cookie: true,
        xfbml: true,
        version: "v13.0",
      );
      final result = await facebookAuth.login();
      expect(result.status, LoginStatus.success);
      expect(result.accessToken, isNotNull);
      expect(await facebookAuth.accessToken, isA<AccessToken>());
      final Map<String, dynamic> userData = await facebookAuth.getUserData();
      expect(userData.containsKey("email"), true);
      final FacebookPermissions? permissions = await facebookAuth.permissions;
      expect(permissions, isNotNull);
      expect(permissions!.granted.length > 0, true);
      expect(permissions.declined.length == 0, true);
      await facebookAuth.logOut();
      expect(await facebookAuth.accessToken, null);
    });

    test('express login', () async {
      bool logged = false;
      when(
        () => facebookAuth.expressLogin(),
      ).thenAnswer(
        (_) async {
          logged = true;
          return LoginResult(
            status: LoginStatus.success,
            accessToken: accessToken,
          );
        },
      );

      when(
        () => facebookAuth.accessToken,
      ).thenAnswer(
        (_) async => logged ? accessToken : null,
      );

      expect(await facebookAuth.accessToken, null);
      final result = await facebookAuth.expressLogin();
      expect(result.status, LoginStatus.success);
    });

    test('autoLogAppEventsEnabled', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      bool isAutoLogAppEventsEnabled = false;
      when(
        () => facebookAuth.isAutoLogAppEventsEnabled,
      ).thenAnswer(
        (_) async => isAutoLogAppEventsEnabled,
      );

      when(
        () => facebookAuth.autoLogAppEventsEnabled(true),
      ).thenAnswer(
        (_) async {
          isAutoLogAppEventsEnabled = true;
        },
      );

      expect(await facebookAuth.isAutoLogAppEventsEnabled, false);
      await facebookAuth.autoLogAppEventsEnabled(true);
      expect(await facebookAuth.isAutoLogAppEventsEnabled, true);
    });
  });
}

class MockFacebookAuth extends Mock implements FacebookAuth {}
