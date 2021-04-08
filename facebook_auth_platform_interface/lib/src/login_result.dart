import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show required;
import 'access_token.dart';

enum LoginStatus { success, cancelled, failed, operationInProgress }

/// class to handle a login request
class LoginResult {
  final LoginStatus status;
  final String message;
  final AccessToken accessToken;

  LoginResult({
    @required this.status,
    this.message,
    this.accessToken,
  });

  /// returns an instance of LoginResult class from a PlatformException
  static getResultFromException(PlatformException e) {
    // CANCELLED, FAILED, OPERATION_IN_PROGRESS
    LoginStatus status;
    switch (e.code) {
      case "CANCELLED":
        status = LoginStatus.cancelled;
        break;
      case "OPERATION_IN_PROGRESS":
        status = LoginStatus.operationInProgress;
        break;
      default:
        status = LoginStatus.failed;
    }

    return LoginResult(status: status, message: e.message);
  }
}
