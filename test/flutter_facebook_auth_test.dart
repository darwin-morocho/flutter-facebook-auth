import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_facebook_auth');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
   //expect(await FlutterFacebookAuth.platformVersion, '42');
  });
}
