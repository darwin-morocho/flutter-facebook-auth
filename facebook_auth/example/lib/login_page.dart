import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Generates a cryptographically secure random nonce of the specified length.
/// Defaults to 32 characters, which is recommended for most use cases.
String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FacebookAuth.instance;
  String? _nonce;

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
      await _getUserProfile(accessToken);
    } else {
      setState(() {
        _state = LoginNotAuthenticated();
      });
    }
  }

  Future<void> _getUserProfile(AccessToken accessToken) async {
    if (accessToken is LimitedToken) {
      log('token nonce: ${accessToken.nonce}');
      log('_nonce: $_nonce');
    } else {
      log('accessToken is ClassicToken');
    }

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
    _nonce = generateNonce();

    setState(() {
      _state = LoginLoading();
    });
    final result = await _auth.login(
      loginTracking: LoginTracking.limited,
      nonce: _nonce,
    );

    switch (result.status) {
      case LoginStatus.success:
        await _getUserProfile(result.accessToken!);
      case LoginStatus.cancelled:
      case _:
        log(
          '${result.status.name}: ${result.message}',
        );
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
        child: SafeArea(
          child: Center(
            child: switch (_state) {
              LoginLoading() => CircularProgressIndicator(),
              LoginNotAuthenticated() => ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              LoginSuccessful(user: final user) => ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    ElevatedButton(
                      onPressed: _logout,
                      child: Text('Log Out'),
                    ),
                    Text(
                      prettyPrint(
                        user.toJson(),
                      ),
                    ),
                  ],
                ),
            },
          ),
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
  final AccessToken accessToken;
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
        'accessToken': accessToken.toJson(),
        'pictureProfile': pictureProfile,
        'email': email,
      };
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}
