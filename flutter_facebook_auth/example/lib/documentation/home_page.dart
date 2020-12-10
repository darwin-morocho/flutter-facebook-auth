import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> _userData;
  AccessToken _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  /// uses the facebook SDK to check if a user has an active session
  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;
    setState(() {
      _checking = false;
    });
    print("is Logged:::: ${accessToken != null}");
    if (accessToken != null) {
      // if the user is logged
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData();
      _userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      // setState(() {
      //   _userData = userData;
      // });
    }
  }

  _login() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();
      print(prettyPrint(accessToken.toJson()));
      _userData = await FacebookAuth.instance.getUserData();
    } on FacebookAuthException catch (e) {
      print(e.errorCode);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.9), BlendMode.color),
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://apperle.dawoud.org/neomi/images/background/osman-rana-253127-unsplash.jpg",
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.blueAccent.withOpacity(0.8),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "flutter_facebook_auth",
                        style: GoogleFonts.roboto(
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      ),
                      SelectableText(
                        "The easiest way to add facebook login to your flutter app, get user information, profile picture and more.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Sing in with Facebook",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onTap: _login,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: Pulse(
                      infinite: true,
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  if (_checking)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.8),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
