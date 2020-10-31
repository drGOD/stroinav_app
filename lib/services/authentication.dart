import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String verificationId;
String status;

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String dataOfStudent, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  Future<String> signIn(String email, String password) async {
    final AuthCredential credentialEmail = EmailAuthProvider.getCredential(
      email: email,
      password: password,
    );
    FirebaseUser user = await _auth.signInWithCredential(credentialEmail);
    return user.uid;
  }

  Future<String> signUp(String email, String dataOfStudent, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    UserUpdateInfo newData = new UserUpdateInfo();
    newData.displayName = dataOfStudent;
    user.updateProfile(newData);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
