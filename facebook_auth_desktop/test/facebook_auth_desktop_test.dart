import 'dart:convert';

import 'package:facebook_auth_desktop/facebook_auth_desktop.dart';
import 'package:facebook_auth_desktop/src/custom_http_client.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/src/response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'app.meedu/facebook_auth_desktop',
  );

  const MethodChannel secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  test(
    'initialization',
    () {
      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockHttpClient(),
      );

      expect(() => plugin.login(), throwsAssertionError);
    },
  );

  test(
    'login > ok',
    () async {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "signIn":
            return 'https://www.facebook.com/connect/login_success.html#access_token=EAAS5elFDcaYBAK1H14Xsv7JWqGFtppMumfVEhczQKcxvgAr454EHrnlwV9T3Wz9ZAJ8uNRhEFBOiLMKagM6ZBYIYZCM7VR2DL88aVtrT0iADG93hMeEChBofpJPyymQHZANp26zchVXcGVWssftG7IwGJXeji4immsyZA6RCZCJ7SeIpsR8NUd53mZBhjSZBXaNYq01ZCsM2zpQZDZD&data_access_expiration_time=1659801242&expires_in=3958&long_lived_token=EAAS5elFDcaYBAJZBqce4JM0D5PNq11UVboeax5T8dBCk9vrDtBCdNTzqpK0NUr0YSMZBPdDSMudqzv7ALVkSUgagC4wcgxHJVALtHfIpr6ONuhCnMZAce7oNbBXaUGgSh0v8JSrJHLlnRw9fENPpoYFvCry0A3SCZC3iQm7hKZAh8G8cnOcPK&granted_scopes=email%2Cpublic_profile&denied_scopes=&state=GQfBqzTSeOPlDfOazUKhRVtEmMBjYDi1';
        }
      });

      secureStorageChannel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "write":
            return null;

          case "read":
            return jsonEncode(mockAccessToken);
        }
      });

      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockHttpClient(),
      );

      plugin.webAndDesktopInitialize(
        appId: 'appId',
        cookie: true,
        xfbml: true,
        version: 'v13.0',
      );

      final result = await plugin.login();
      expect(result.accessToken, isNotNull);
      final userData = await plugin.getUserData();
      expect(userData.isNotEmpty, true);
    },
  );

  test(
    'login > cancelled',
    () async {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "signIn":
            return null;
        }
      });

      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockHttpClient(),
      );

      plugin.webAndDesktopInitialize(
        appId: 'appId',
        cookie: true,
        xfbml: true,
        version: 'v13.0',
      );

      final result = await plugin.login();
      expect(result.status, LoginStatus.cancelled);
    },
  );

  test(
    'login > fails',
    () async {
      channel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "signIn":
            return 'https://www.facebook.com/connect/login_success.html#access_token=EAAS5elFDcaYBAK1H14Xsv7JWqGFtppMumfVEhczQKcxvgAr454EHrnlwV9T3Wz9ZAJ8uNRhEFBOiLMKagM6ZBYIYZCM7VR2DL88aVtrT0iADG93hMeEChBofpJPyymQHZANp26zchVXcGVWssftG7IwGJXeji4immsyZA6RCZCJ7SeIpsR8NUd53mZBhjSZBXaNYq01ZCsM2zpQZDZD&data_access_expiration_time=1659801242&expires_in=3958&long_lived_token=EAAS5elFDcaYBAJZBqce4JM0D5PNq11UVboeax5T8dBCk9vrDtBCdNTzqpK0NUr0YSMZBPdDSMudqzv7ALVkSUgagC4wcgxHJVALtHfIpr6ONuhCnMZAce7oNbBXaUGgSh0v8JSrJHLlnRw9fENPpoYFvCry0A3SCZC3iQm7hKZAh8G8cnOcPK&granted_scopes=email%2Cpublic_profile&denied_scopes=&state=GQfBqzTSeOPlDfOazUKhRVtEmMBjYDi1';
        }
      });

      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockFailHttpClient(),
      );

      plugin.webAndDesktopInitialize(
        appId: 'appId',
        cookie: true,
        xfbml: true,
        version: 'v13.0',
      );

      final result = await plugin.login();
      expect(result.status, LoginStatus.failed);
    },
  );

  test(
    'login > logged',
    () async {
      int i = 0;
      secureStorageChannel.setMockMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case "delete":
            return null;

          case "read":
            if (i == 0) {
              return jsonEncode(mockAccessToken);
            }
            return null;
        }
      });

      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockHttpClient(),
      );

      plugin.webAndDesktopInitialize(
        appId: 'appId',
        cookie: true,
        xfbml: true,
        version: 'v13.0',
      );

      final accessToken = await plugin.accessToken;
      expect(accessToken, isNotNull);
      final permissions = await plugin.permissions;
      expect(permissions?.granted, isNotNull);
      final userData = await plugin.getUserData();
      expect(userData.isNotEmpty, true);
      i++;
      await plugin.logOut();
      expect(await plugin.accessToken, isNull);
    },
  );

  test(
    'UnimplementedError',
    () async {
      final plugin = FacebookAuthDesktopPlugin(
        httpClient: MockHttpClient(),
      );

      expect(
        () {
          plugin.autoLogAppEventsEnabled(true);
        },
        throwsUnimplementedError,
      );

      expect(
        () {
          plugin.expressLogin();
        },
        throwsUnimplementedError,
      );
      expect(await plugin.isAutoLogAppEventsEnabled, false);
      expect(plugin.isWebSdkInitialized, false);
    },
  );
}

class MockHttpClient implements CustomHttpClient {
  @override
  Future<Response> get(Uri url) async {
    final response = jsonEncode({
      'id': '12345678',
    });

    return Response.bytes(
      response.codeUnits,
      200,
    );
  }
}

class MockFailHttpClient implements CustomHttpClient {
  @override
  Future<Response> get(Uri url) async {
    final response = jsonEncode({
      'id': '12345678',
    });

    return Response.bytes(
      response.codeUnits,
      500,
    );
  }
}

const mockAccessToken = {
  "userId": "136742241592917",
  "token":
      "EAAS5elFDcaYBAB4KyXaxBtEBjkgYpAEZAZAFuV6VHxxfC29l6ZCjgEmYKVguY3Uos5fQ0blVON2WccIvLCQ72EFHDa0ZAmludHCbGN3jNDpzq2L78X74dYTYBAokZAzFWZBwg2biPlEboXkZCWjNWubmE3TES5er3yxZArstszCbQtfue1ECxkjzHhwUkdYNuMJgzo1WVUa4Cc7z2M029srT",
  "expires": 4102462800000,
  "lastRefresh": 1610051315980,
  "applicationId": "1329834907365798",
  "graphDomain": "facebook",
  "isExpired": false,
  "grantedPermissions": ["email", "user_link"],
  "declinedPermissions": [],
};
