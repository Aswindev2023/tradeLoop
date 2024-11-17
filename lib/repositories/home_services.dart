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

      // Search by name
      queryRef = queryRef.where('name', isGreaterThanOrEqualTo: query);
      queryRef = queryRef.where('name', isLessThanOrEqualTo: '$query\uf8ff');

      // Apply category filter if provided
      if (categoryId != null) {
        queryRef = queryRef.where('categoryId', isEqualTo: categoryId);
      }

      // Apply tags filter if provided
      if (tags != null && tags.isNotEmpty) {
        queryRef = queryRef.where('tags', arrayContainsAny: tags);
      }

      QuerySnapshot querySnapshot = await queryRef.get();

      // Filter out products belonging to the current user
      return querySnapshot.docs
          .map((doc) => HomePageProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .where((product) => product.sellerId != userId)
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
