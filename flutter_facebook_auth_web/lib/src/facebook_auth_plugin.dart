import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'facebook_auth_web.dart';

/// A web implementation of the FlutterFacebookAuth plugin.
class FlutterFacebookAuthPlugin {
  final FacebookAuthWeb _auth = FacebookAuthWeb();

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'app.meedu/flutter_facebook_auth',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    final pluginInstance = FlutterFacebookAuthPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'isLogged':
        return await _auth.isLogged();

      case 'getUserData':
        final String fields = call.arguments['fields'];
        return await _auth.getUserData(fields);

      case 'login':
        final List<String> permissions =
            List<String>.from(call.arguments['permissions']);
        return await _auth.login(permissions);

      case 'logOut':
        return await _auth.logOut();

      default:
        throw PlatformException(
          code: 'Unimplemented',
          message:
              'flutter_facebook_auth for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
