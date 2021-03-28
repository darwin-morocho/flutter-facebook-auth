import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/pages/splash/widgets/login_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash_controller.dart';
import 'package:flutter_meedu/state.dart';
import 'dart:math' as math;

class SplashPage extends ProviderPage<SplashController> {
  @override
  SplashController create(_) {
    return SplashController(FacebookAuth.instance);
  }

  @override
  Widget buildPage(BuildContext context, SplashController controller) {
    return SimpleBuilder<SplashController>(
      builder: (_) => Scaffold(
        body: Stack(
          children: [
            _.isLogged == null
                ? Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  )
                : LoginView(),
            Positioned(
              right: -100,
              top: -40,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: InkWell(
                  onTap: () async {
                    final url = "https://github.com/darwin-morocho/flutter-facebook-auth";
                    if (await canLaunch(url)) {
                      launch(url);
                    }
                  },
                  child: Container(
                    width: 250,
                    height: 150,
                    padding: const EdgeInsets.only(top: 70),
                    color: Color(0xff29434e),
                    child: Image.asset(
                      'assets/github.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
