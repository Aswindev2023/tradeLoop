import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/repositories/user_repository.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserCredential> signIn(String email, String password) async {
    try {
      // Step 1: Attempt to sign in
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Fetch user details from Firestore
      final String uid = credential.user?.uid ?? '';
      if (uid.isEmpty) {
        throw Exception('Failed to retrieve user ID.');
      }

      final UserModel? user = await UserRepository().getUser(uid);

      // Step 3: Check if the user is banned
      if (user != null) {
        final isBanned = user.isBanned ?? false;

        if (isBanned) {
          await signOut();
          throw Exception(
              'Your account has been banned. Please contact support.');
        }
      }

      // Step 4: Return the UserCredential if not banned
      return credential;
    } catch (e) {
      // Re-throw the error for further handling
      rethrow;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web sign-in
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        return await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // Mobile sign-in
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth == null) return null;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Google Sign-In failed: ${e.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
