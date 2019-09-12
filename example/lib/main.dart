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
  String _token;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _printCredentials(AccessToken accessToken) {
    _token = accessToken.token;
    print("userId: ${accessToken.userId}");
    print("token: $_token");
    print("expires: ${accessToken.expires}");
    print("permissions: ${accessToken.permissions.toString()}");
  }

  _checkIfIsLogged() async {
    final accessToken = await _fb.isLogged();
    if (accessToken != null) {
      _printCredentials(accessToken);
      // now you can call to  _fb.getUserData();
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      print(userData.runtimeType);
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    final result = await _fb.login();
    // final result = await _fb.login(permissions:['email','user_birthday']);
    print("login result ${result.toString()}");
    if (result.status == 200) {
      _printCredentials(result.accessToken);
      // get the user data
      final userData = await _fb.getUserData();
      // final userData = await _fb.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    } else if (result.status == 403) {
      print("login cancelled");
    } else {
      print("login failed");
    }
  }

  _logOut() async {
    await _fb.logOut();
    _token = null;
    setState(() {
      _userData = null;
    });
  }

  _checkPermissions() async {
    final dynamic response = await _fb.permissionsStatus(_token);
    print("permissions: ${response.toString()}");
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
            Text(_userData != null ? _userData.toString() : "NO LOGGED"),
            _userData != null
                ? CupertinoButton(
                    child: Text("Check permissions"),
                    onPressed: _checkPermissions,
                    color: Colors.greenAccent,
                  )
                : Container(),
            SizedBox(height: 20),
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
