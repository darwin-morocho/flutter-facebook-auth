import 'package:flutter/services.dart';

import 'access_token.dart';

enum LoginStatus { success, cancelled, failed, operationInProgress }

/// class to handle a login request
class LoginResult {
  /// contain status of a previous login request
  final LoginStatus status;

  /// contain a message when the login request fail
  final String? message;

  /// contain the access token information for the current session
  /// this will be null when the login request fail
  final AccessToken? accessToken;

  LoginResult({
    required this.status,
    this.message,
    this.accessToken,
  });

  /// returns an instance of LoginResult class from a PlatformException
  static getResultFromException(PlatformException e) {
    // CANCELLED, FAILED, OPERATION_IN_PROGRESS
    late LoginStatus status;
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
