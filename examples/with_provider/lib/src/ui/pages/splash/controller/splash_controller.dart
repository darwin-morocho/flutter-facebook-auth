import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/routes.dart';

import '../../../global/controllers/session_controller.dart';
import '../../../mixins/auth_checker_mixin.dart';

class SplashController extends ChangeNotifier with AuthCheckerMixin {
  SplashController({
    required this.auth,
    required this.sessionController,
  });

  @override
  final FacebookAuth auth;

  @override
  final SessionController sessionController;

  String? _routeName;
  String? get routeName => _routeName;

  Future<void> init() async {
    _routeName = await isLogged() ? Routes.home : Routes.login;
    notifyListeners();
  }
}
