import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class RecentlyViewedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRecentlyViewedProduct(String userId, String productId) async {
    final docRef = _firestore.collection('recentlyviewed').doc(userId);
    await docRef.set({
      'productIds': FieldValue.arrayUnion([productId])
    }, SetOptions(merge: true));

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      List<String> productIds =
          List<String>.from(snapshot.data()?['productIds'] ?? []);
      if (productIds.length > 10) {
        productIds = productIds.sublist(1);
        await docRef.update({'productIds': productIds});
      }
    }
  }

  Future<List<HomePageProductModel>> getRecentlyViewedProducts(
      String userId) async {
    print('Fetching recently viewed products for user: $userId');
    final snapshot =
        await _firestore.collection('recentlyviewed').doc(userId).get();
    if (snapshot.exists) {
      final productIds =
          List<String>.from(snapshot.data()?['productIds'] ?? []);
      print('Fetched product IDs: $productIds');

      if (productIds.isNotEmpty) {
        final productsQuery = await _firestore
            .collection('products')
            .where('productId', whereIn: productIds)
            .get();

        return productsQuery.docs.map((doc) {
          return HomePageProductModel.fromFirestore(doc.data());
        }).toList();
      }
    } else {
      print('No recently viewed products found for user: $userId');
    }
    return [];
  }
}
