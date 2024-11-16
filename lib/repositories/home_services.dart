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
          .where(
            'sellerId',
            isNotEqualTo: userId,
          )
          .where(
            'categoryId',
            isEqualTo: categoryId,
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
}
