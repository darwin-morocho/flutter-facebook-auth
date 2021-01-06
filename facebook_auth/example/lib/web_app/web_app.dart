import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home/home_page.dart';

class WebApp extends StatelessWidget {
  const WebApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.abelTextTheme(),
      ),
    );
  }
}
