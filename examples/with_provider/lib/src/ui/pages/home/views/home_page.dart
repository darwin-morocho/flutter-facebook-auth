// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_example/src/domain/repositories/session_repository.dart';
import 'package:flutter_facebook_auth_example/src/ui/global/controllers/session_controller.dart';
import 'package:flutter_facebook_auth_example/src/ui/routes/routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<SessionController>().user!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _logOut(context),
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            if (user.profilePicture != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user.profilePicture!,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            Center(
              child: Text(user.name),
            ),
            if (user.email != null)
              Center(
                child: Text(user.email!),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context) async {
    final SessionRepository auth = context.read();
    await auth.logOut();
    final SessionController sessionController = context.read();
    sessionController.updateUser(null);
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
