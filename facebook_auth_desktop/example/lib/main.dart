import 'package:flutter/material.dart';
import 'package:facebook_auth_desktop/facebook_auth_desktop.dart';

final plugin = FacebookAuthDesktopPlugin();

void main() {
  plugin.webAndDesktopInitialize(
    appId: '1329834907365798',
    cookie: true,
    version: 'v13.0',
    xfbml: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _signIn() {
    plugin.login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: _signIn,
            child: const Text('sign in'),
          ),
        ),
      ),
    );
  }
}
