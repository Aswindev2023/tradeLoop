import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';

class ProductsService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel product) async {
    try {
      assert(product.productId != null, 'User ID cannot be null.');
      final jsonMap = product.toJson();
      await _productCollection.doc(product.productId).set(jsonMap);
    } catch (e) {
      print('Error storing user data: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _productCollection.where('sellerId', isEqualTo: userId).get();

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching products by user ID: $e');
      return [];
    }
  }
}
