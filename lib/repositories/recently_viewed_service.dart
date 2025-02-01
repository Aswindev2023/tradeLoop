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
        print('snapshot exists:${snapshot.exists}');
        productIds = List<String>.from(snapshot.data()?['productIds'] ?? []);
        print('resulting product ids:$productIds');
      }

      // Remove the product ID if it already exists
      bool removed = productIds.remove(productId);
      print('removed product id from firebase: $removed');
      // Add the product ID to the beginning of the list
      productIds.insert(0, productId);
      print('added new product id to firebase at the first position:');
      print(
          'the product id to be deleted and re inserted at the 0th position is:$productId');
      // Trim the list to keep only the 10 most recent IDs
      if (productIds.length > 10) {
        productIds = productIds.sublist(0, 10);
      }
      print('the final recently view product list is:$productIds');
      // Update Firestore with the new list
      await docRef.set({'productIds': productIds}, SetOptions(merge: true));
    } catch (e) {
      print(
          'adding new products to recently viewed is failed due to :${e.toString()}');
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
      print('Fetched product IDs from Firestore: $productIds');

      if (productIds.isNotEmpty) {
        final productsQuery = await _firestore
            .collection('products')
            .where('productId', whereIn: productIds)
            .get();

        print(
            'Fetched products from Firestore: ${productsQuery.docs.map((doc) => doc.id).toList()}');

        final fetchedProducts = productsQuery.docs.map((doc) {
          print('Mapping product ID: ${doc.id}');
          return HomePageProductModel.fromFirestore(doc.data());
        }).toList();

        // Ensure the fetched products are in the same order as `productIds`
        final orderedProducts = productIds
            .map((id) {
              final product = fetchedProducts.firstWhere(
                (product) => product.productId == id,
                orElse: () {
                  print(
                      'Warning: Product ID $id not found in fetched products');
                  return HomePageProductModel.empty();
                },
              );
              return product;
            })
            .where((product) => product.productId.isNotEmpty)
            .toList();
        print(
            'Ordered products: ${orderedProducts.map((product) => product.productId).toList()}');

        return orderedProducts.cast<HomePageProductModel>();
      }
    } else {
      print('No recently viewed products found for user: $userId');
    }

    return [];
  }
}
