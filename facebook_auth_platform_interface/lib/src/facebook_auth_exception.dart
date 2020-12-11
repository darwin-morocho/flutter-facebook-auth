/// class to save the error data when usign the facebook SDK
///
class FacebookAuthException implements Exception {
  /// the error code
  final String errorCode; // CANCELLED, FAILED, OPERATION_IN_PROGRESS

  /// the error message
  final String message;

  FacebookAuthException(this.errorCode, this.message);
}
