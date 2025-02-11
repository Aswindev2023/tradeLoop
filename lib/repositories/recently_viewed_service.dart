import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class RecentlyViewedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRecentlyViewedProduct(String userId, String productId) async {
    try {
      final docRef = _firestore.collection('recentlyviewed').doc(userId);

      // Fetch the current list of product IDs from Firestore
      final snapshot = await docRef.get();
      List<String> productIds = [];

      if (snapshot.exists) {
        productIds = List<String>.from(snapshot.data()?['productIds'] ?? []);
      }

      // Remove the product ID if it already exists
      productIds.remove(productId);

      // Add the product ID to the beginning of the list
      productIds.insert(0, productId);

      // Trim the list to keep only the 10 most recent IDs
      if (productIds.length > 10) {
        productIds = productIds.sublist(0, 10);
      }

      // Update Firestore with the new list
      await docRef.set({'productIds': productIds}, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  //Fetch recently viewed products of current user
  Future<List<HomePageProductModel>> getRecentlyViewedProducts(
      String userId) async {
    final snapshot =
        await _firestore.collection('recentlyviewed').doc(userId).get();

    if (snapshot.exists) {
      final productIds =
          List<String>.from(snapshot.data()?['productIds'] ?? []);

      if (productIds.isNotEmpty) {
        final productsQuery = await _firestore
            .collection('products')
            .where('productId', whereIn: productIds)
            .get();

        final fetchedProducts = productsQuery.docs.map((doc) {
          return HomePageProductModel.fromFirestore(doc.data());
        }).toList();

        // Ensure the fetched products are in the same order as `productIds`
        final orderedProducts = productIds
            .map((id) {
              final product = fetchedProducts.firstWhere(
                (product) => product.productId == id,
                orElse: () {
                  return HomePageProductModel.empty();
                },
              );
              return product;
            })
            .where((product) => product.productId.isNotEmpty)
            .toList();

        return orderedProducts.cast<HomePageProductModel>();
      }
    }

    return [];
  }
}
