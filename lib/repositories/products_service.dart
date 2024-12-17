import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/repositories/product_image_upload_service.dart';

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

  Future<ProductModel?> getProductDetailsById(String productId) async {
    try {
      DocumentSnapshot doc = await _productCollection.doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('product do not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
  }

  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      ProductImageUploadService().deleteImages(imageUrls);
      print('the image urls are:$imageUrls');
      await _productCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      if (product.productId == null) {
        throw Exception('Product ID is required');
      }

      // Step 1: Compare existing image URLs with the new ones
      List<String> oldImageUrls = product.imageUrls;

      // Initialize the newImageUrls as an empty list
      List<String?> newImageUrls = [];

      // Only delete the old images if new images are provided and they differ
      if (product.imageUrls.isNotEmpty) {
        // If there are new images, check if they are different from the old ones
        if (oldImageUrls.isEmpty ||
            !listEquals(oldImageUrls, product.imageUrls)) {
          print('Deleting existing images...');
          // Delete the old images before uploading new ones
          await ProductImageUploadService().deleteImages(oldImageUrls);
          newImageUrls =
              await ProductImageUploadService().uploadImages(product.imageUrls);
        } else {
          // If no change in images, keep the old URLs
          newImageUrls = oldImageUrls;
        }
      } else {
        // If no new images are provided, keep the old ones
        newImageUrls = oldImageUrls;
      }

      // Step 2: Ensure only valid URLs are used (filter out nulls)
      List<String> validImageUrls = newImageUrls.whereType<String>().toList();

      // Step 3: Update the product model with the new image URLs
      final updatedProduct = product.copyWith(imageUrls: validImageUrls);

      // Step 4: Update Firestore with the new product data
      final jsonMap = updatedProduct.toJson();
      DocumentReference docRef = _productCollection.doc(product.productId);
      await docRef.update(jsonMap);

      print('Product updated successfully with ID: ${product.productId}');
      return updatedProduct;
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }
}
