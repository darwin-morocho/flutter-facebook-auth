import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'my_app.dart';

void main() {
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: "1329834907365798",
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  runApp(MyApp());
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}
