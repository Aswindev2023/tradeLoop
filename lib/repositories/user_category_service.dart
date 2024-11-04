import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';

class UserCategoryService {
  final CollectionReference _categoryList =
      FirebaseFirestore.instance.collection('categories');

  Future<List<CategoryModel?>> getCategories() async {
    try {
      QuerySnapshot querySnapshot = await _categoryList.get();
      return querySnapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
