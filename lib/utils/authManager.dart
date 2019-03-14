import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../map.dart';

// Auth Manager class for managing authentication function
class AuthManager {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static googleSignIn() async {
    String _username;

    _googleSignIn.signIn().then((result) {
      result.authentication.then((googleKey) {
        FirebaseAuth.instance
            .signInWithGoogle(
                idToken: googleKey.idToken, accessToken: googleKey.accessToken)
            .then((signedIn) {
          _username = signedIn.displayName;
          return FireMap();
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  static signOut() async {
    return await _auth.signOut();
  }
}
