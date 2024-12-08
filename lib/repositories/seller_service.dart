import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class SellerService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Fetch products by seller ID
  Future<List<HomePageProductModel>> getProductsByUserId(String userId) async {
    try {
      print('Fetching products for userId: $userId');
      QuerySnapshot querySnapshot =
          await _productCollection.where('sellerId', isEqualTo: userId).get();

      return querySnapshot.docs.map((doc) {
        return HomePageProductModel.fromFirestore(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching products by user ID: $e');
      return [];
    }
  }

  // Fetch user details by user ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      print('Fetching user details for uid: $uid');
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}
