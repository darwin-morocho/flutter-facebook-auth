import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/domain/models/user.dart';
import 'package:flutter_facebook_auth_example/src/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final FacebookAuth _auth;

  SessionRepositoryImpl(this._auth);
  @override
  Future<LoginResult> logIn() {
    return _auth.login();
  }

  @override
  Future<User?> get user async {
    if (await _auth.accessToken != null) {
      final userData = await _auth.getUserData();

      if (userData.isNotEmpty) {
        final user = User(
          userId: userData['id'],
          name: userData['name'],
          email: userData['email'],
          profilePicture: userData['picture']?['data']?['url'],
        );
        return user;
      }
    }
    return null;
  }
  
  @override
  Future<void> logOut() {
    return _auth.logOut();
  }
}
