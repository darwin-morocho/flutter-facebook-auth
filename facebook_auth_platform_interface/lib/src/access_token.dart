const maxMillisecondsSinceEpoch = 8640000000000000;
const minMillisecondsSinceEpoch = -8640000000000000;

/// Class that contains the facebook access token data
class AccessToken {
  /// DateTime with the expires date of this token
  final DateTime expires;

  /// DateTime with the last refresh date of this token
  final DateTime lastRefresh;

  /// the facebook user id
  final String userId;

  /// token provided by facebook to make api calls to the GRAPH API
  final String token;

  /// the facebook application Id
  final String applicationId;

  /// the graph Domain name returned by facebook
  final String? graphDomain;

  /// list of string with the rejected permission by the user (on Web is null)
  final List<String>? declinedPermissions;

  /// list of string with the approved permission by the user (on Web is null)
  final List<String>? grantedPermissions;

  /// is `true` when the token is expired
  final bool isExpired;

  /// DateTime with the date at which user data access expires
  final DateTime dataAccessExpirationTime;

  AccessToken({
    required this.declinedPermissions,
    required this.grantedPermissions,
    required this.userId,
    required this.expires,
    required this.lastRefresh,
    required this.token,
    required this.applicationId,
    this.graphDomain,
    required this.isExpired,
    required this.dataAccessExpirationTime,
  });

  /// convert the data provided for the platform channel to one instance of AccessToken
  ///
  /// [json] data returned by the platform channel
  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      userId: json['userId'],
      token: json['token'],
      expires: DateTime.fromMillisecondsSinceEpoch(
        json['expires'].clamp(
          minMillisecondsSinceEpoch,
          maxMillisecondsSinceEpoch,
        ),
      ),
      lastRefresh: DateTime.fromMillisecondsSinceEpoch(json['lastRefresh']),
      applicationId: json['applicationId'],
      graphDomain: json['graphDomain'],
      isExpired: json['isExpired'],
      declinedPermissions: json['declinedPermissions'] != null
          ? List<String>.from(json['declinedPermissions'])
          : null,
      grantedPermissions: json['grantedPermissions'] != null
          ? List<String>.from(json['grantedPermissions'])
          : null,
      dataAccessExpirationTime:
          DateTime.fromMillisecondsSinceEpoch(json['dataAccessExpirationTime']),
    );
  }

  /// convert this instance to one Map
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'token': token,
        'expires': expires.millisecondsSinceEpoch,
        'lastRefresh': lastRefresh.millisecondsSinceEpoch,
        'applicationId': applicationId,
        'graphDomain': graphDomain,
        'isExpired': isExpired,
        'grantedPermissions': grantedPermissions,
        'declinedPermissions': declinedPermissions,
        'dataAccessExpirationTime': dataAccessExpirationTime.toIso8601String(),
      };
}
