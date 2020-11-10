class AccessToken {
  final DateTime expires, lastRefresh;
  final String userId, token, applicationId, graphDomain;

  final List<String> declinedPermissions;
  final List<String> grantedPermissions;
  final bool isExpired;

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
