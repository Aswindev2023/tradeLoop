part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductAddedSuccess extends ProductState {
  final ProductModel newProduct;

  const ProductAddedSuccess({required this.newProduct});

  @override
  List<Object> get props => [newProduct];
}

class ProductDeletedSuccess extends ProductState {
  final String productId;

  const ProductDeletedSuccess({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

//add product page state:
class ProductFormState extends ProductState {
  final bool isAvailable;
  final LatLng? pickedLocation;
  final String? locationName;
  final List<String> pickedImages;
  final List<String> tags;
  final CategoryModel? selectedCategory;
  final Map<String, dynamic> formFields;

  const ProductFormState({
    this.isAvailable = false,
    this.pickedLocation,
    this.locationName,
    this.pickedImages = const [],
    this.tags = const [],
    this.selectedCategory,
    this.formFields = const {},
  });

  ProductFormState copyWith({
    bool? isAvailable,
    LatLng? pickedLocation,
    String? locationName,
    List<String>? pickedImages,
    List<String>? tags,
    CategoryModel? selectedCategory,
    Map<String, dynamic>? formFields,
  }) {
    return ProductFormState(
      isAvailable: isAvailable ?? this.isAvailable,
      pickedLocation: pickedLocation ?? this.pickedLocation,
      locationName: locationName ?? this.locationName,
      pickedImages: pickedImages ?? this.pickedImages,
      tags: tags ?? this.tags,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      formFields: formFields ?? this.formFields,
    );
  }

  @override
  List<Object> get props => [
        isAvailable,
        pickedLocation ?? const LatLng(10.850516, 76.271080),
        locationName ?? '',
        pickedImages,
        tags,
        selectedCategory ?? CategoryModel(id: null, name: ''),
        formFields,
      ];
}
