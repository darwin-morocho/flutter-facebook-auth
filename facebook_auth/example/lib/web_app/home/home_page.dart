import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/banner.dart';
import './widgets/readme.dart';

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyBanner(),
            SizedBox(height: 20),
            Readme(),
          ],
        ),
      ),
    );
  }
}
