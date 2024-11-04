import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';

class ProductsService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<ProductModel> addProduct(ProductModel product) async {
    print('add product is being called with this product model:$product');

    try {
      final jsonMap = product.toJson();
      DocumentReference docRef = await _productCollection.add(jsonMap);
      print('this is the prodcut id:$docRef');
      final generatedId = docRef.id;
      await docRef.update({'productId': generatedId});

      return product.copyWith(productId: generatedId);
    } catch (e) {
      print('Error storing product: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByUserId(String userId) async {
    try {
      print('this is the passed userId in getproduct by id:$userId');
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
