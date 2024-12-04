import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class WishlistServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Add product to wishlist
  Future<void> addProductToWishlist(String userId, String productId) async {
    final wishlistRef = _firestore.collection('wishlist').doc(userId);
    await wishlistRef.set({
      'productIds': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
  }
  //remove product from wishlist

  Future<void> removeProductFromWishlist(
      String userId, String productId) async {
    final wishlistRef = _firestore.collection('wishlist').doc(userId);
    await wishlistRef.update({
      'productIds': FieldValue.arrayRemove([productId]),
    });
  }
  //fetching product from wishlist

  Future<List<HomePageProductModel>> fetchWishlist(String userId) async {
    print('Fetching wishlist for user: $userId');
    final doc = await _firestore.collection('wishlist').doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      print('No wishlist found for user: $userId');
      return [];
    }

    final List<String> productIds =
        List<String>.from(doc.data()?['productIds'] ?? []);
    print('Fetched product IDs: $productIds');

    if (productIds.isEmpty) return [];

    final List<HomePageProductModel> products = [];

    // Fetch products in chunks of 30
    for (var i = 0; i < productIds.length; i += 30) {
      final chunk = productIds.sublist(
          i, i + 30 > productIds.length ? productIds.length : i + 30);
      final querySnapshot = await _firestore
          .collection('products')
          .where('productId', whereIn: chunk)
          .get();

      products.addAll(querySnapshot.docs
          .map((doc) => HomePageProductModel.fromFirestore(doc.data())));
    }

    return products;
  }
}
