abstract class LoginBehavior {
  /// Specifies that login should attempt login in using the Facebook App, and if that does not work fall back to web dialog auth. This is the default behavior.
  static const NATIVE_WITH_FALLBACK = "NATIVE_WITH_FALLBACK";

  /// Specifies that login should only attempt to login using the Facebook App. If the Facebook App cannot be used then the login fails.
  static const NATIVE_ONLY = "NATIVE_ONLY";

  /// Specifies that login should only attempt to use Katana Proxy Login.
  static const KATANA_ONLY = "KATANA_ONLY";

  /// Specifies that only the web dialog auth should be used.
  static const WEB_ONLY = "WEB_ONLY";

  /// Specifies that only the web view dialog auth should be used
  static const WEB_VIEW_ONLY = "WEB_VIEW_ONLY";

  /// Specifies that only the web dialog auth (from anywhere) should be used
  static const DIALOG_ONLY = "DIALOG_ONLY";

  /// Specifies that device login authentication flow should be used.
  static const DEVICE_AUTH = "DEVICE_AUTH";
}
