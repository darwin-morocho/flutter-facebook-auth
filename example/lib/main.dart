import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _userData;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.isLogged();
    if (accessToken != null) {
      print("accessToken: ${accessToken}");
      // now you can call to  FacebookAuth.getUserData();
      final userData = await FacebookAuth.getUserData();
      // final userData = await FacebookAuth.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    final result = await FacebookAuth.login();
    // final result = await FacebookAuth.login(permissions:['email','user_birthday']);
    print("login result ${result.toString()}");
    if (result['status'] == 200) {
      print("accessToken: ${result['accessToken']}");
      // get the user data
      final userData = await FacebookAuth.getUserData();
      // final userData = await FacebookAuth.getUserData(fields:"email,birthday");
      print("userData: ${userData.toString()}");
      setState(() {
        _userData = userData;
      });
    } else if (result['status'] == 403) {
      print("login cancelled");
    } else {
      print("login failed");
    }
  }

  _logOut() async {
    await FacebookAuth.logOut();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_userData != null ? _userData.toString() : "NO LOGGED"),
            CupertinoButton(
                color: Colors.blue,
                child: Text(
                  _userData != null ? "LOGOUT" : "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _userData != null ? _logOut : _login),
          ],
        ),
      ),
    );
  }
}
