import 'access_token.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginResult {
  final int status;
  final AccessToken accessToken;

  LoginResult({this.status, this.accessToken});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
        status: json['status'] as int,
        accessToken: json['accessToken'] == null
            ? null
            : AccessToken.fromJson(
                Map<String, dynamic>.from(json['accessToken'])));
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'status': status, 'accessToken': accessToken};
}
