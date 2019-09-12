


class AccessToken {
  final int expires;
  final String userId, token;
  final List<String> permissions, declinedPermissions; // null on iOS

  AccessToken(
      {this.userId,
      this.expires,
      this.token,
      this.permissions,
      this.declinedPermissions});

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);
}


AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return AccessToken(
      userId: json['userId'] as String,
      expires: json['expires'] as int,
      token: json['token'] as String,
      permissions:
      (json['permissions'] as List)?.map((e) => e as String)?.toList(),
      declinedPermissions: (json['declinedPermissions'] as List)
          ?.map((e) => e as String)
          ?.toList());
}

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'expires': instance.expires,
      'userId': instance.userId,
      'token': instance.token,
      'permissions': instance.permissions,
      'declinedPermissions': instance.declinedPermissions
    };
