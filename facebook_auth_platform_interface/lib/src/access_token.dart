const maxMillisecondsSinceEpoch = 8640000000000000;
const minMillisecondsSinceEpoch = -8640000000000000;

enum AccessTokenType { classic, limited }

abstract class AccessToken {
  final String tokenString;
  final AccessTokenType type;

  AccessToken({
    required this.tokenString,
    required this.type,
  });

  Map<String, dynamic> toJson();
}

class LimitedToken extends AccessToken {
  final String userId;
  final String userName;
  final String? userEmail;
  final String nonce;

  LimitedToken({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.nonce,
    super.type = AccessTokenType.limited,
    required super.tokenString,
  });

  factory LimitedToken.fromJson(Map<String, dynamic> json) {
    return LimitedToken(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      tokenString: json['token'],
      nonce: json['nonce'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'userId': userId,
        'tokenString': tokenString,
        'nonce': nonce,
        'userEmail': userEmail,
        'userName': userName,
      };
}

/// Class that contains the facebook access token data
class ClassicToken extends AccessToken {
  /// DateTime with the expires date of this token
  final DateTime expires;

  /// the facebook user id
  final String userId;

  /// the facebook application Id
  final String applicationId;

  /// list of string with the rejected permission by the user (on Web is null)
  final List<String>? declinedPermissions;

  /// list of string with the approved permission by the user (on Web is null)
  final List<String>? grantedPermissions;

  final String? authenticationToken;

  ClassicToken({
    required this.declinedPermissions,
    required this.grantedPermissions,
    required this.userId,
    required this.expires,
    required super.tokenString,
    required this.applicationId,
    this.authenticationToken,
    super.type = AccessTokenType.classic,
  });

  /// convert the data provided for the platform channel to one instance of AccessToken
  ///
  /// [json] data returned by the platform channel
  factory ClassicToken.fromJson(Map<String, dynamic> json) {
    return ClassicToken(
      userId: json['userId'],
      tokenString: json['token'] ?? json['tokenString'],
      expires: DateTime.fromMillisecondsSinceEpoch(
        json['expires'].clamp(
          minMillisecondsSinceEpoch,
          maxMillisecondsSinceEpoch,
        ),
      ),
      authenticationToken: json['authenticationToken'],
      applicationId: json['applicationId'],
      declinedPermissions: json['declinedPermissions'] != null
          ? List<String>.from(json['declinedPermissions'])
          : null,
      grantedPermissions: json['grantedPermissions'] != null
          ? List<String>.from(json['grantedPermissions'])
          : null,
    );
  }

  /// convert this instance to one Map
  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'userId': userId,
        'tokenString': tokenString,
        'expires': expires.millisecondsSinceEpoch,
        'applicationId': applicationId,
        'grantedPermissions': grantedPermissions,
        'declinedPermissions': declinedPermissions,
        'authenticationToken': authenticationToken,
      };
}
