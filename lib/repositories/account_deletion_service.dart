import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountDeletionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> deleteUserProducts(String userId) async {
    try {
      final productsSnapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: userId)
          .get();

      for (var doc in productsSnapshot.docs) {
        final productData = doc.data();
        final productImages = List<String>.from(productData['imageUrls'] ?? []);
        // Delete each product image from storage
        for (String imageUrl in productImages) {
          await _storage.refFromURL(imageUrl).delete();
        }
        // Delete product document from Firestore
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting products: $e');
      rethrow;
    }
  }

  Future<void> deleteUserProfileImage(String profileImageUrl) async {
    try {
      if (profileImageUrl.isNotEmpty) {
        await _storage.refFromURL(profileImageUrl).delete();
      }
    } catch (e) {
      print('Error deleting profile image: $e');
      rethrow;
    }
  }

  Future<void> deleteUserAccount(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final profileImageUrl = userDoc.data()?['imagePath'] ?? '';
      if (profileImageUrl.isNotEmpty) {
        await _storage.refFromURL(profileImageUrl).delete();
      }
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user account: $e');
      rethrow;
    }
  }
}
