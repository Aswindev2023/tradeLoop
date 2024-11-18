import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class HomeServices {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<HomePageProductModel>> getProductsExcludingUserId(
      String userId) async {
    try {
      print('Fetching products excluding sellerId: $userId');
      QuerySnapshot querySnapshot = await _productCollection
          .where(
            'sellerId',
            isNotEqualTo: userId,
          )
          .get();

      return querySnapshot.docs.map((doc) {
        return HomePageProductModel.fromFirestore(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching products excluding user ID: $e');
      return [];
    }
  }

  Future<List<HomePageProductModel>> getCategorywiseProducts(
      String userId, String categoryId) async {
    try {
      print(
          'Fetching products excluding sellerId: $userId & categoryId:$categoryId');
      QuerySnapshot querySnapshot = await _productCollection
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => HomePageProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .where((product) => product.sellerId != userId)
          .toList();
    } catch (e) {
      print('Error fetching products excluding user ID: $e');
      return [];
    }
  }

  Future<List<HomePageProductModel>> searchProducts({
    required String query,
    required String userId,
    String? categoryId,
    List<String>? tags,
  }) async {
    try {
      print('Searching products for query: $query');
      Query queryRef = _productCollection;

      // Search by name (partial matching)
      if (query.isNotEmpty) {
        queryRef = queryRef
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: '$query\uf8ff');
      }

      // Execute the query to fetch products by name
      QuerySnapshot querySnapshot = await queryRef.get();
      print(
          'Query Snapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');

      // Map the fetched products into the HomePageProductModel
      List<HomePageProductModel> products = querySnapshot.docs
          .map((doc) => HomePageProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .where((product) =>
              product.sellerId !=
              userId) // Filter out the current user's products
          .toList();

      // Apply category and tag filters if provided
      if (categoryId != null || (tags != null && tags.isNotEmpty)) {
        print('Applying filters: categoryId = $categoryId, tags = $tags');

        // Filter by category if provided
        if (categoryId != null) {
          products = products
              .where((product) => product.categoryId == categoryId)
              .toList();
        }

        // Filter by tags if provided
        if (tags != null && tags.isNotEmpty) {
          products = products
              .where((product) => product.tags.any((tag) => tags.contains(tag)))
              .toList();
        }
      }

      return products;
    } catch (e) {
      print('Error during searchProducts: $e');
      return [];
    }
  }
}
