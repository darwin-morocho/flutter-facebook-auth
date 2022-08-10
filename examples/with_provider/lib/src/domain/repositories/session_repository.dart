import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/domain/models/user.dart';

abstract class SessionRepository {
  Future<User?> get user;
  Future<LoginResult> logIn();
}
