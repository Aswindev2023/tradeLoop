import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';

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
    //Adding products
    on<ProductAdded>((event, emit) async {
      emit(ProductLoading());
      try {
        List<String?> imageUrls =
            await _imageUploadService.uploadImages(event.newProduct.imageUrls);

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
        emit(ProductError(message: 'Failed to add product: $e'));
      }
    });
    //loading products
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
    //Saving products changes
    on<SaveProductChanges>((event, emit) async {
      emit(ProductLoading());
      try {
        final updatedProduct =
            await _productsService.updateProduct(event.updatedProduct);

        emit(ProductAddedSuccess(newProduct: updatedProduct));
      } catch (e) {
        emit(ProductError(message: 'Failed to update product: $e'));
      }
    });
    //edit product page form:
    on<InitializeProductFormWithData>((event, emit) {
      final product = event.product;

      emit(ProductFormState(
        pickedLocation: product.location,
        locationName: product.locationName,
        tags: event.product.tags,
        selectedCategory: CategoryModel(
            id: event.product.categoryId, name: event.product.categoryName),
        formFields: {
          'isAvailable': product.isAvailable,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'condition': product.condition,
        },
        isAvailable: product.isAvailable,
        pickedImages: event.product.imageUrls,
      ));
    });

    //addproduct page form
    on<InitializeProductForm>((event, emit) {
      emit(const ProductFormState(
        pickedLocation: null,
        locationName: 'Pick a Location',
        tags: [],
        selectedCategory: null,
        formFields: {},
        isAvailable: true,
        pickedImages: [],
      ));
    });
    on<UpdateLocation>((event, emit) {
      try {
        if (state is ProductFormState) {
          final currentState = state as ProductFormState;
          emit(currentState.copyWith(
            pickedLocation: event.pickedLocation,
            locationName: event.locationName,
          ));
        }
      } catch (e) {
        rethrow;
      }
    });

    on<UpdateTags>((event, emit) {
      if (state is ProductFormState) {
        final currentState = state as ProductFormState;
        emit(currentState.copyWith(tags: event.tags));
      } else {}
    });

    on<UpdateCategory>((event, emit) {
      if (state is ProductFormState) {
        final currentState = state as ProductFormState;
        emit(currentState.copyWith(selectedCategory: event.selectedCategory));
      } else {}
    });

    on<UpdateFormFields>((event, emit) {
      if (state is ProductFormState) {
        final currentState = state as ProductFormState;
        emit(currentState.copyWith(formFields: event.formFields));
      }
    });
    on<UpdateAvailability>((event, emit) {
      if (state is ProductFormState) {
        final currentState = state as ProductFormState;
        emit(currentState.copyWith(isAvailable: event.isAvailable));
      }
    });

    on<UpdateImages>((event, emit) {
      if (state is ProductFormState) {
        final currentState = state as ProductFormState;

        emit(currentState.copyWith(pickedImages: event.imagePaths));
      }
    });

    //deletion

    on<DeleteProduct>((event, emit) async {
      try {
        await _productsService.deleteProduct(event.productId, event.imageUrls);
        final updatedProducts =
            await _productsService.getProductsByUserId(event.userId);
        emit(ProductsLoaded(products: updatedProducts));
      } catch (e) {
        emit(ProductError(message: 'Failed to delete product: $e'));
      }
    });
  }
}
