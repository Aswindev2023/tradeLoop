import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/repositories/product_image_upload_service.dart';
import 'package:trade_loop/repositories/products_service.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsService _productsService = ProductsService();
  final ProductImageUploadService _imageUploadService =
      ProductImageUploadService();
  ProductBloc() : super(ProductInitial()) {
    on<ProductAdded>((event, emit) async {
      emit(ProductLoading());
      try {
        List<String?> imageUrls =
            await _imageUploadService.uploadImages(event.newProduct.imageUrls);
        print('this is the image url retrived from storage:$imageUrls');
        if (imageUrls.contains(null)) {
          emit(const ProductError(
              message: 'Failed to upload one or more images.'));
          return;
        }
        final List<String> nonNullableImageUrls =
            imageUrls.whereType<String>().toList();

        final newProductWithImages =
            event.newProduct.copyWith(imageUrls: nonNullableImageUrls);
        final addedProduct =
            await _productsService.addProduct(newProductWithImages);

        emit(ProductAddedSuccess(newProduct: addedProduct));
      } catch (e) {
        print('Error storing product: $e');
        emit(ProductError(message: 'Failed to add product: $e'));
      }
    });

    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products =
            await _productsService.getProductsByUserId(event.userId);
        emit(ProductsLoaded(products: products));
      } catch (e) {
        emit(ProductError(message: 'Failed to load products: $e'));
      }
    });
  }
}
