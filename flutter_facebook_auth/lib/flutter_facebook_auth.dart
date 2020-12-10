import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
export 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';

/// Generic class that extends of FacebookAuthPlatform interface
class FacebookAuth extends FacebookAuthPlatform {
  FacebookAuth._internal();
  static FacebookAuth get instance => FacebookAuthPlatform.instance;
}
