import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FacebookAuth.instance;

  late LoginPageState _state;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _state = LoginLoading();
    });

    final accessToken = await _auth.accessToken;

    if (accessToken != null) {
      await _getUserProfile(accessToken.token);
    } else {
      setState(() {
        _state = LoginNotAuthenticated();
      });
    }
  }

  Future<void> _getUserProfile(String accessToken) async {
    final data = await _auth.getUserData();
    if (data.isEmpty) {
      await _logout();
      return;
    }

    setState(() {
      _state = LoginSuccessful(
        User(
          userId: data['id'],
          accessToken: accessToken,
          name: data['name'],
          pictureProfile: data['picture']?['data']?['url'],
          email: data['email'],
        ),
      );
    });
  }

  Future<void> _logout() async {
    await _auth.logOut();

    setState(() {
      _state = LoginNotAuthenticated();
    });
  }

  Future<void> _login() async {
    setState(() {
      _state = LoginLoading();
    });
    final result = await _auth.login(
      loginTracking: LoginTracking.limited,
    );

    switch (result.status) {
      case LoginStatus.success:
        await _getUserProfile(result.accessToken!.token);
      case LoginStatus.cancelled:
      case _:
        setState(() {
          _state = LoginNotAuthenticated();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: switch (_state) {
            LoginLoading() => CircularProgressIndicator(),
            LoginNotAuthenticated() => ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            LoginSuccessful(user: final user) => Text(
                prettyPrint(
                  user.toJson(),
                ),
              ),
          },
        ),
      ),
    );
  }
}

// Abstract base class representing login page states
sealed class LoginPageState {}

// State representing the login page is loading
class LoginLoading extends LoginPageState {}

// State representing the user is not logged in
class LoginNotAuthenticated extends LoginPageState {}

// State representing the user is successfully logged in
class LoginSuccessful extends LoginPageState {
  final User user;

  LoginSuccessful(this.user);
}

class User {
  final String userId;
  final String accessToken;
  final String name;
  final String? pictureProfile;
  final String? email;

  User({
    required this.userId,
    required this.accessToken,
    required this.name,
    required this.pictureProfile,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'accessToken': accessToken,
        'pictureProfile': pictureProfile,
        'email': email,
      };
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}
