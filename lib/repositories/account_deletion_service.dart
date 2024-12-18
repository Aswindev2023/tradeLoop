import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountDeletionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Reauthenticate a user using email and password
  Future<void> reauthenticateWithEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("No user is currently signed in.");

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception("Email reauthentication failed: $e");
    }
  }

  /// Reauthenticate a user using Google Sign-In
  Future<void> reauthenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Google sign-in was canceled.");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = _auth.currentUser;
      if (user == null) throw Exception("No user is currently signed in.");

      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception("Google reauthentication failed: $e");
    }
  }

  /// Retrieves the user's profile image path from Firestore.
  Future<String> _getUserProfileImagePath(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        return data['profileImagePath'] ?? '';
      }
      return '';
    } catch (e) {
      throw Exception("Failed to retrieve profile image path: $e");
    }
  }

  /// Deletes the user's profile image from Firebase Storage.
  Future<void> _deleteUserProfileImage(String profileImagePath) async {
    try {
      if (profileImagePath.isNotEmpty) {
        final ref = _storage.ref().child(profileImagePath);
        await ref.delete();
      }
    } catch (e) {
      throw Exception("Failed to delete user profile image: $e");
    }
  }

  /// Deletes all product images associated with the user from Firebase Storage.
  Future<void> _deleteProductImages(List<String> productImagePaths) async {
    try {
      for (String imagePath in productImagePaths) {
        if (imagePath.isNotEmpty) {
          final ref = _storage.ref().child(imagePath);
          await ref.delete();
        }
      }
    } catch (e) {
      throw Exception("Failed to delete product images: $e");
    }
  }

  /// Deletes all products associated with the user from Firestore.
  Future<void> _deleteUserProducts(String userId) async {
    try {
      final productsSnapshot = await _firestore
          .collection('products')
          .where('userId', isEqualTo: userId)
          .get();

      final productImagePaths = <String>[];

      final batch = _firestore.batch();
      for (var doc in productsSnapshot.docs) {
        final data = doc.data();
        if (data['imagePath'] != null) {
          productImagePaths.add(data['imagePath'] as String);
        }
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (productImagePaths.isNotEmpty) {
        await _deleteProductImages(productImagePaths);
      }
    } catch (e) {
      throw Exception("Failed to delete user products: $e");
    }
  }

  /// Deletes the user document from Firestore.
  Future<void> _deleteUserDocument(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception("Failed to delete user document: $e");
    }
  }

  /// Deletes the user's wishlist document from Firestore.
  Future<void> _deleteUserWishlist(String userId) async {
    try {
      final wishlistDoc = _firestore.collection('wishlist').doc(userId);
      await wishlistDoc.delete();
    } catch (e) {
      throw Exception("Failed to delete user wishlist: $e");
    }
  }

  /// Deletes the "recently viewed" document for the user.
  Future<void> _deleteRecentlyViewed(String userId) async {
    try {
      final recentlyViewedDoc =
          _firestore.collection('recentlyviewed').doc(userId);
      await recentlyViewedDoc.delete();
    } catch (e) {
      throw Exception("Failed to delete recently viewed: $e");
    }
  }

  /// Deletes all chats associated with the user.
  Future<void> _deleteUserChats(String userId) async {
    try {
      final chatDocs = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();

      for (var chat in chatDocs.docs) {
        final chatId = chat.id;

        // Deleting  messages in the chat
        final messagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .get();

        final batch = _firestore.batch();
        for (var message in messagesSnapshot.docs) {
          batch.delete(message.reference);
        }
        await batch.commit();

        // Deleting  the chat document
        await _firestore.collection('chats').doc(chatId).delete();
      }
    } catch (e) {
      throw Exception("Failed to delete user chats: $e");
    }
  }

  /// Deletes the Firebase Authentication user.
  Future<void> _deleteAuthUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print('user is deleted');
      }
    } catch (e) {
      throw Exception("Failed to delete authentication user: $e");
    }
  }

  Future<void> deleteUserAccount(String userId) async {
    try {
      final profileImagePath = await _getUserProfileImagePath(userId);

      await Future.wait([
        _deleteUserProducts(userId),
        _deleteUserDocument(userId),
        _deleteUserWishlist(userId),
        _deleteRecentlyViewed(userId),
        _deleteUserChats(userId),
        _deleteUserProfileImage(profileImagePath),
      ]);

      await _deleteAuthUser();
    } catch (e) {
      throw Exception("Failed to delete user account: $e");
    }
  }
}
