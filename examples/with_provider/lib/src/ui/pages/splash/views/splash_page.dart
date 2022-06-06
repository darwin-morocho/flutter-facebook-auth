import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth_example/src/ui/pages/splash/controller/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(
      auth: context.read(),
      sessionController: context.read(),
    );

    _controller.addListener(_listener);

    WidgetsBinding.instance.endOfFrame.then(
      (_) => _controller.init(),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    final routeName = _controller.routeName;
    if (routeName != null && mounted) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
