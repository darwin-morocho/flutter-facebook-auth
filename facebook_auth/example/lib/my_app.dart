import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth_example/pages/splash/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.black,
          textTheme: CupertinoTextThemeData(
            textStyle: GoogleFonts.nunito(),
          ),
        ),
      ),
    );
  }
}
