import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth_example/pages/splash/splash_controller.dart';
import 'package:flutter_facebook_auth_example/pages/splash/widgets/loading.dart';
import 'package:flutter_facebook_auth_example/pages/splash/widgets/login_button.dart';
import 'package:flutter_facebook_auth_example/pages/splash/widgets/patreons.dart';
import 'package:flutter_facebook_auth_example/pages/splash/widgets/supported_platforms.dart';
import 'package:flutter_facebook_auth_example/utils/max_width.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SplashController>();
    final isLogged = controller.isLogged;
    return SafeArea(
      child: Align(
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth(context),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back!".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.chango(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff29434e),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Sign In using Facebook thanks to ",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: "flutter_facebook_auth",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  if (kIsWeb) Patreons(),
                  SizedBox(height: 30),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Column(
                      children: [
                        if (!isLogged)
                          Image.asset(
                            'assets/typing.png',
                          ),
                        if (isLogged && controller.userData != null) ...[
                          ClipOval(
                            child: Image.network(
                              controller.userData['picture']['data']['url'],
                              width: 80,
                            ),
                          ),
                          Text(
                            "Hi ${controller.userData['name']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                        SizedBox(height: 30),
                        LoginButton(),
                      ],
                    ),
                  ),
                  SupportedPlatforms(),
                ],
              ),
            ),
            if (controller.fetching) Loading(),
          ],
        ),
      ),
    );
  }
}
