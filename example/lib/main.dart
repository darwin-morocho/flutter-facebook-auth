import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fb = FacebookAuth();
  dynamic _userData;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _checkIfIsLogged() async {
    final accessToken = await _fb.isLogged();
    if (accessToken != null) {
      print("accessToken: ${accessToken.toString()}");
      // now you can call to  _fb.getUserData();
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    final result = await _fb.login();
    // final result = await _fb.login(permissions:['email','user_birthday']);
    print("login result ${result.toString()}");
    if (result['status'] == LonginResult.success) {
      print("accessToken: ${result['accessToken'].toString()}");
      // get the user data
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      print("userData: ${userData.toString()}");
      setState(() {
        _userData = userData;
      });
    } else if (result['status'] == LonginResult.cancelled) {
      print("login cancelled");
    } else {
      print("login failed");
    }
  }

  _logOut() async {
    await _fb.logOut();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_userData != null ? JsonEncoder.withIndent('  ').convert(_userData) : "NO LOGGED"),
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
