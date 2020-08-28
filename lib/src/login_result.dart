import 'access_token.dart';

/// this class is used to covert the platform channels responses to dart
class LoginResult {
  /// 200, 403, 500
  final int status;

  /// access tolen with extra data
  final AccessToken accessToken;
  final List<String> declinedPermissions;
  final List<String> grantedPermissions;

  LoginResult({
    this.status,
    this.accessToken,
    this.declinedPermissions = const [],
    this.grantedPermissions = const [],
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'] == null
        ? null
        : AccessToken.fromJson(Map<String, dynamic>.from(json['accessToken']));

    return LoginResult(
      status: json['status'] as int,
      accessToken: accessToken,
      declinedPermissions: json['declinedPermissions'] != null
          ? List<String>.from(json['declinedPermissions'])
          : [],
      grantedPermissions: json['grantedPermissions'] != null
          ? List<String>.from(json['grantedPermissions'])
          : [],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status,
        'accessToken': accessToken,
        'grantedPermissions': grantedPermissions,
        'declinedPermissions': declinedPermissions
      };
}
