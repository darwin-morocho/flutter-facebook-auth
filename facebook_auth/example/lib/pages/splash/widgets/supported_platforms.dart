import 'package:flutter/material.dart';

class SupportedPlatforms extends StatelessWidget {
  const SupportedPlatforms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 35),
        Text(
          "Supported platforms",
          style: TextStyle(
            color: Color(0xff29434e),
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/android.png',
                  width: 50,
                  height: 50,
                  color: Colors.lightGreen,
                ),
                SizedBox(height: 5),
                Text(
                  "Android",
                  style: TextStyle(color: Colors.lightGreen),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Image.asset(
                  'assets/ios.png',
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 5),
                Text(
                  "iOS",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Image.asset(
                  'assets/web.png',
                  width: 45,
                  height: 45,
                  color: Colors.lightBlueAccent,
                ),
                SizedBox(height: 5),
                Text(
                  "Web",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
