import 'package:flutter/services.dart';

const channelName = 'app.meedu/facebook_auth_desktop';

class PlatformChannel {
  final _channel = const MethodChannel(channelName);

  Future<String?> signIn(String signInUri, String redirectUri) {
    return _channel.invokeMethod(
      'signIn',
      {
        'signInUri': signInUri,
        'redirectUri': redirectUri,
      },
    );
  }
}
