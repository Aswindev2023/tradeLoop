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
        final products = await Future.wait(productIds.map((id) async {
          try {
            final productSnapshot =
                await _firestore.collection('products').doc(id).get();
            if (productSnapshot.exists) {
              final product =
                  HomePageProductModel.fromFirestore(productSnapshot.data()!);
              print('Fetched product: $product');
              return product;
            } else {
              print('Product not found for ID: $id');
            }
          } catch (e) {
            print('Error fetching product for ID: $id - $e');
          }
          return null;
        }));
        return products.whereType<HomePageProductModel>().toList();
      }
    } else {
      print('No recently viewed products found for user: $userId');
    }
    return [];
  }
}
