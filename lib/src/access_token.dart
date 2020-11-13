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

  // the facebook application Id
  final String applicationId;

  final String graphDomain;

  /// list of string with the rejected permission by the user
  final List<String> declinedPermissions;

  /// list of string with the approved permission by the user
  final List<String> grantedPermissions;

  // is `true` when the token is expired
  final bool isExpired;

  /// constrcutor
  AccessToken({
    this.declinedPermissions,
    this.grantedPermissions,
    this.userId,
    this.expires,
    this.lastRefresh,
    this.token,
    this.applicationId,
    this.graphDomain,
    this.isExpired,
  });

  /// convert the data provided for the platform channel to one instance of AccessToken
  ///
  /// [json] data returned by the platform channel
  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      userId: json['userId'],
      token: json['token'],
      expires: DateTime.fromMillisecondsSinceEpoch(json['expires']),
      lastRefresh: DateTime.fromMillisecondsSinceEpoch(json['lastRefresh']),
      applicationId: json['applicationId'],
      graphDomain: json['graphDomain'],
      isExpired: json['isExpired'],
      declinedPermissions: json['declinedPermissions'] != null
          ? List<String>.from(json['declinedPermissions'])
          : [],
      grantedPermissions: json['grantedPermissions'] != null
          ? List<String>.from(json['grantedPermissions'])
          : [],
    );
  }

  /// convert this instance to one Map
  Map<String, dynamic> toJson() => {
        'userId': this.userId,
        'token': this.token,
        'expires': this.expires.toIso8601String(),
        'lastRefresh': this.lastRefresh.toIso8601String(),
        'applicationId': this.applicationId,
        'graphDomain': this.graphDomain,
        'isExpired': this.isExpired,
        'grantedPermissions': this.grantedPermissions,
        'declinedPermissions': this.declinedPermissions,
      };
}
