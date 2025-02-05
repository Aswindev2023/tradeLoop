import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class HomeServices {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  // Helper function to check if the seller is banned
  Future<bool> isSellerBanned(String sellerId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sellerId)
          .get();

      // Safely access the isBanned field using null-aware operators
      return (userDoc.data() as Map<String, dynamic>?)?['isBanned'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Fetch products excluding a specific userId and check if sellers are banned
  Future<List<HomePageProductModel>> getProductsExcludingUserId(
      String userId) async {
    try {
      QuerySnapshot querySnapshot = await _productCollection
          .where('sellerId', isNotEqualTo: userId)
          .get();

      List<HomePageProductModel> products = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String sellerId = data['sellerId'] ?? '';

        bool isBanned = await isSellerBanned(sellerId);

        if (!isBanned) {
          products.add(HomePageProductModel.fromFirestore(data));
        }
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  // Fetch category-wise products and check if sellers are banned
  Future<List<HomePageProductModel>> getCategorywiseProducts(
      String userId, String categoryId) async {
    try {
      QuerySnapshot querySnapshot = await _productCollection
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<HomePageProductModel> products = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String sellerId = data['sellerId'] ?? '';

        bool isBanned = await isSellerBanned(sellerId);

        if (!isBanned && sellerId != userId) {
          products.add(HomePageProductModel.fromFirestore(data));
        }
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  // Search products with multiple filters and check if sellers are banned
  Future<List<HomePageProductModel>> searchProducts({
    required String query,
    required String userId,
    List<String>? categoryIds,
    List<String>? tags,
    List<Map<String, dynamic>>? priceRanges,
  }) async {
    try {
      Query queryRef = _productCollection;

      // Search by name
      if (query.isNotEmpty) {
        queryRef = queryRef
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: '$query\uf8ff');
      }

      QuerySnapshot querySnapshot = await queryRef.get();

      List<HomePageProductModel> products = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String sellerId = data['sellerId'] ?? '';

        bool isBanned = await isSellerBanned(sellerId);

        if (!isBanned && sellerId != userId) {
          products.add(HomePageProductModel.fromFirestore(data));
        }
      }

      // Apply additional filters
      if ((categoryIds != null && categoryIds.isNotEmpty) ||
          (tags != null && tags.isNotEmpty) ||
          (priceRanges != null && priceRanges.isNotEmpty)) {
        // Filter by category
        if (categoryIds != null && categoryIds.isNotEmpty) {
          products = products
              .where((product) => categoryIds.contains(product.categoryId))
              .toList();
        }

        // Filter by tags
        if (tags != null && tags.isNotEmpty) {
          products = products
              .where((product) => product.tags.any((tag) => tags.contains(tag)))
              .toList();
        }

        // Filter by price
        if (priceRanges != null && priceRanges.isNotEmpty) {
          products = products.where((product) {
            return priceRanges.any((range) {
              final min = range['min'] as int?;
              final max = range['max'] as int?;
              return (min == null || product.price >= min) &&
                  (max == null || product.price <= max);
            });
          }).toList();
        }
      }

      return products;
    } catch (e) {
      return [];
    }
  }
}
