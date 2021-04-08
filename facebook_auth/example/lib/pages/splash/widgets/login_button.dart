import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth_example/pages/splash/splash_controller.dart';
import 'package:flutter_facebook_auth_example/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLogged = context.select<SplashController, bool>((_) => _.isLogged);
    return RoundedButton(
      onPressed: () async {
        final _ = context.read<SplashController>();
        if (isLogged) {
          await _.logout();
        } else {
          final isOk = await _.login();
          if (!isOk) {
            final SnackBar snackBar = SnackBar(
              content: Text(
                "Login Cancelled",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      fullWidth: false,
      backgroundColor: Color(0xff29434e),
      borderColor: Color(0xff29434e),
      label: isLogged ? "Log Out" : "Sign In with Facebook",
    );
  }
}
