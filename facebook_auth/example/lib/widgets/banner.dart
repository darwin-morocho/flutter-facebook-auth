import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_btn.dart';

class MyBanner extends StatefulWidget {
  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  /// uses the facebook SDK to check if a user has an active session
  Future<void> _checkIfIsLogged() async {
    _checking = false;
    print("is Logged:::: ${_accessToken != null}");
    if (_accessToken != null) {
      // if the user is logged
      // now you can call to  FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData();
      _userData = await _facebookAuth.getUserData();
    }
    setState(() {});
  }

  _login() async {
    try {
      _checking = true;
      setState(() {});
      _accessToken = await _facebookAuth.login();
      _userData = await _facebookAuth.getUserData();
    } on FacebookAuthException catch (e) {
      print(e.errorCode);
    } finally {
      _checking = false;
      setState(() {});
    }
  }

  void _logOut() async {
    _checking = true;
    setState(() {});
    await _facebookAuth.logOut();
    _accessToken = null;
    _userData = null;
    _checking = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.blueAccent.withOpacity(0.8), BlendMode.color),
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
              SizedBox(height: 40),
              Image.network(
                'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png',
                width: 150,
              ),
              Text(
                "flutter_facebook_auth",
                style: TextStyle(
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
              if (_userData == null)
                MyBtn("Try the sing in with Facebook", onPressed: _login),
              if (_userData != null) ...[
                Text(
                  "Hi ${_userData!['name']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                MyBtn("Log Out", onPressed: _logOut),
              ],
              SizedBox(height: 30),
              Text(
                "Supported platforms",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/android.png',
                        width: 50,
                        height: 50,
                        color: Colors.lightGreen,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Android",
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Image.asset(
                        'assets/ios.png',
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "iOS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Image.asset(
                        'assets/web.png',
                        width: 45,
                        height: 45,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Web",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
          Positioned(
            right: -100,
            top: -40,
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: InkWell(
                onTap: () async {
                  final url =
                      "https://github.com/darwin-morocho/flutter-facebook-auth";
                  if (await canLaunch(url)) {
                    launch(url);
                  }
                },
                child: Container(
                  width: 250,
                  height: 150,
                  padding: const EdgeInsets.only(top: 70),
                  color: Colors.white,
                  child: Image.asset(
                    'assets/github.png',
                    color: Colors.blueAccent,
                  ),
                ),
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
            ),
        ],
      ),
    );
  }
}
