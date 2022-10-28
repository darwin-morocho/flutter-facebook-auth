import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/data/repositories_impl/session_repository_impl.dart';
import 'package:flutter_facebook_auth_example/src/domain/repositories/session_repository.dart';
import 'package:flutter_facebook_auth_example/src/ui/global/controllers/session_controller.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/app_routes.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: '1329834907365798',
      cookie: true,
      xfbml: true,
      version: "v14.0",
    );
  }
  runApp(
    MultiProvider(
      providers: [
        Provider<SessionRepository>(
          create: (_) => SessionRepositoryImpl(FacebookAuth.i),
        ),
        Provider<SessionController>(
          create: (_) => SessionController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: () async {
        final sessionRepository = Provider.of<SessionRepository>(context);
        final user = await sessionRepository.user;
        if (user != null) {
          // ignore: use_build_context_synchronously
          context.read<SessionController>().updateUser(user);
          return true;
        }
        return false;
      }.call(),
      builder: (_, snapShot) {
        if (!snapShot.hasData) {
          return const MediaQuery(
            data: MediaQueryData(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Material(
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          routes: appRoutes,
          initialRoute: snapShot.data! ? Routes.home : Routes.login,
        );
      },
    );
  }
}
