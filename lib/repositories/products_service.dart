import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/repositories/product_image_upload_service.dart';

class ProductsService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final jsonMap = product.toJson();
      DocumentReference docRef = await _productCollection.add(jsonMap);

      final generatedId = docRef.id;
      await docRef.update({'productId': generatedId});

      return product.copyWith(productId: generatedId);
    } catch (e) {
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
      return [];
    }
  }

  Future<ProductModel?> getProductDetailsById(String productId) async {
    try {
      DocumentSnapshot doc = await _productCollection.doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      ProductImageUploadService().deleteImages(imageUrls);

      await _productCollection.doc(productId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      if (product.productId == null) {
        throw Exception('Product ID is required');
      }

      List<String> oldImageUrls = product.imageUrls;

      List<String?> newImageUrls = [];

      if (product.imageUrls.isNotEmpty) {
        if (oldImageUrls.isEmpty ||
            !listEquals(oldImageUrls, product.imageUrls)) {
          await ProductImageUploadService().deleteImages(oldImageUrls);
          newImageUrls =
              await ProductImageUploadService().uploadImages(product.imageUrls);
        } else {
          newImageUrls = oldImageUrls;
        }
      } else {
        newImageUrls = oldImageUrls;
      }

      List<String> validImageUrls = newImageUrls.whereType<String>().toList();

      final updatedProduct = product.copyWith(imageUrls: validImageUrls);

      final jsonMap = updatedProduct.toJson();
      DocumentReference docRef = _productCollection.doc(product.productId);
      await docRef.update(jsonMap);

      return updatedProduct;
    } catch (e) {
      rethrow;
    }
  }
}
