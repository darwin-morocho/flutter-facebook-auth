import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/routes.dart';

import '../pages/home/views/home_page.dart';
import '../pages/login/views/login_page.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.login: (_) => const LoginPage(),
    Routes.home: (_) => const HomePage(),
  };
}
