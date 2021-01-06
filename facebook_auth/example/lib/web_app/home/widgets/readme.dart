import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Readme extends StatefulWidget {
  @override
  _ReadmeState createState() => _ReadmeState();
}

class _ReadmeState extends State<Readme> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1024),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Wrap(
                spacing: 5,
                children: [
                  Link(
                    child: Image.network(
                      "https://img.shields.io/pub/v/flutter_facebook_auth?color=%2300b0ff&label=flutter_facebook_auth&style=flat-square",
                    ),
                    url: "https://pub.dev/packages/flutter_facebook_auth",
                  ),
                  Image.network(
                    "https://img.shields.io/github/last-commit/the-meedu-app/flutter-facebook-auth?color=%23ffa000&style=flat-square",
                  ),
                  Image.network(
                    "https://img.shields.io/github/license/the-meedu-app/flutter-facebook-auth?style=flat-square",
                  ),
                  Image.network(
                    "https://img.shields.io/github/stars/the-meedu-app/flutter-facebook-auth?style=social",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Link extends StatelessWidget {
  final Widget child;
  final String url;
  const Link({Key key, @required this.child, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: child,
      onTap: () async {
        if (await canLaunch(url)) {
          launch(url);
        }
      },
    );
  }
}
