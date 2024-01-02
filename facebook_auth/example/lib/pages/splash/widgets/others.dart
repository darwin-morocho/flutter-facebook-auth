// import 'package:flutter/material.dart';


// class AuthenticationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Social Media Login'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await FlutterSocialLogin.loginToFacebook(
//                   appId: 'YOUR_FACEBOOK_APP_ID',
//                   redirectUri: 'YOUR_FACEBOOK_REDIRECT_URI',
//                   permissions: ['email'],
//                 );

//                 print(result);
//               },
//               child: Text('Login with Facebook'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await FlutterSocialLogin.loginToTwitter(
//                   consumerKey: 'YOUR_TWITTER_CONSUMER_KEY',
//                   consumerSecret: 'YOUR_TWITTER_CONSUMER_SECRET',
//                   redirectUri: 'YOUR_TWITTER_REDIRECT_URI',
//                 );

//                 print(result);
//               },
//               child: Text('Login with Twitter'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await FlutterSocialLogin.loginToGoogle(
//                   clientId: 'YOUR_GOOGLE_CLIENT_ID',
//                   redirectUri: 'YOUR_GOOGLE_REDIRECT_URI',
//                 );

//                 print(result);
//               },
//               child: Text('Login with Google'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await FlutterSocialLogin.loginToInstagram(
//                   clientId: 'YOUR_INSTAGRAM_CLIENT_ID',
//                   redirectUri: 'YOUR_INSTAGRAM_REDIRECT_URI',
//                 );

//                 print(result);
//               },
//               child: Text('Login with Instagram'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
