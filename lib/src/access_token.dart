import 'package:json_annotation/json_annotation.dart';

part 'access_token.g.dart';

@JsonSerializable()
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
