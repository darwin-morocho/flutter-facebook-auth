class AccessToken {
  final int expires;
  final String userId, token;

  AccessToken({this.userId, this.expires, this.token});

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      userId: json['userId'] as String,
      expires: json['expires'] as int,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'expires': this.expires,
        'userId': this.userId,
        'token': this.token,
      };
}
