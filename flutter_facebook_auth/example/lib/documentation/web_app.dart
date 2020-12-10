import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth_example/documentation/home/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class WebApp extends StatelessWidget {
  const WebApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
    );
  }
}
