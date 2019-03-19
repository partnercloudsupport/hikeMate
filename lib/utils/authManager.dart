import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import '../map.dart';

// Auth Manager class for managing authentication function
class AuthService {
  // Dependencies
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Shared State for Widgets
  Observable<Map<String, dynamic>> profile; //custom data in firebase
  Observable<FirebaseUser> user; // firebase user
  Observable<DocumentSnapshot> location;
  PublishSubject loading = PublishSubject();
  String _username;

  // getter for username
  String get username => _username;

  // Constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    //start
    loading.add(true);

    //signIn with google account
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    //login to firebase and pass idToken and accessToken from googleUser
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    updateUserData(user);

    loading.add(false);
    // print("signed in " + user.displayName);
    _username = user.displayName;
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData(
        {'uid': user.uid, 'email': user.email, 'displayName': user.displayName},
        merge: true);
  }

  signOut() async {
    return await _auth.signOut();
  }
}

final AuthService authService = AuthService();
