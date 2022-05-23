// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/ui/global/controllers/session_controller.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => _login(context),
                child: const Text('Login with facebook'),
              ),
            ),
            if (_fetching)
              Positioned.fill(
                child: Container(
                  color: Colors.white54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    setState(() {
      _fetching = true;
    });
    final FacebookAuth auth = context.read();
    final result = await auth.login();
    if (result.status == LoginStatus.success) {
      final userData = await auth.getUserData();
      if (userData.isNotEmpty) {
        final user = User(
          userId: userData['id'],
          name: userData['name'],
          email: userData['email'],
          profilePicture: userData['picture']?['data']?['url'],
        );

        if (mounted) {
          final SessionController sessionController = context.read();
          sessionController.updateUser(user);
          Navigator.pushReplacementNamed(context, Routes.home);

          return;
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(result.status.name),
        ),
      );
    }
    setState(() {
      _fetching = false;
    });
  }
}
