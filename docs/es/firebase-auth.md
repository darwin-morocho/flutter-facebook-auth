```dart
import 'package:firebase_auth/firebase_auth.dart';
.
.
.
Future<UserCredential?> signInWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login();
  if(result.status == LoginStatus.success){
    // Create a credential from the access token
    final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  return null;
}

```