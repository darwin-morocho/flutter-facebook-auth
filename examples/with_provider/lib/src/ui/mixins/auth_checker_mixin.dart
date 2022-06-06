import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/domain/models/user.dart';
import 'package:flutter_facebook_auth_example/src/ui/global/controllers/session_controller.dart';

mixin AuthCheckerMixin {
  FacebookAuth get auth;
  SessionController get sessionController;

  Future<bool> isLogged() async {
    final accessToken = await auth.accessToken;
    if (accessToken != null) {
      final userData = await auth.getUserData();
      if (userData.isNotEmpty) {
        final user = User(
          userId: userData['id'],
          name: userData['name'],
          email: userData['email'],
          profilePicture: userData['picture']?['data']?['url'],
        );

        sessionController.updateUser(user);
        return true;
      }
    }

    return false;
  }
}
