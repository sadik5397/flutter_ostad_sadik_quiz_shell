import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<User?> restoreSessionIfPossible() async {
    try {
      final existingUser = firebaseAuth.currentUser;
      if (existingUser != null) return existingUser;
      final googleUser = await googleSignIn.signInSilently();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on Exception catch (e) {
      debugPrint("Failed to restore auth session: $e");
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      return await firebaseAuth.signInWithCredential(credential);
    } on Exception catch (e) {
      debugPrint("Failed to sign in with Google: $e");
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}
