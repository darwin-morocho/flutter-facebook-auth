@TestOn('browser')

import 'package:flutter_facebook_auth_web/flutter_facebook_auth_web.dart';
import 'package:flutter_facebook_auth_web/src/auth.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';

import 'mock/mock_data.dart';

/// create a new instance of FacebookAuthPlugin with Mock Data
FlutterFacebookAuthPlugin getPlugin() => FlutterFacebookAuthPlugin();

void main() {
  group('web authentication', () {
    final plugin = getPlugin();

    test('login request', () async {
      expect(await plugin.accessToken, null);
      Map<String, dynamic> userData = await plugin.getUserData();
      expect(userData.containsKey('name'), false);
      final result = await plugin.login();
      expect(result.status, LoginStatus.success);
      expect(result.accessToken, isNotNull);
      expect(await plugin.accessToken, isNotNull);
      userData = await plugin.getUserData();
      expect(userData.containsKey('name'), true);
      await plugin.logOut();
      expect(await plugin.accessToken, null);
    });
  });
}
