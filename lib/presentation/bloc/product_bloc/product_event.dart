part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductPageLoaded extends ProductEvent {
  final String productId;
  const ProductPageLoaded({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddProductPressed extends ProductEvent {}

class ProductAdded extends ProductEvent {
  final ProductModel newProduct;
  const ProductAdded({required this.newProduct});
}

class LoadProducts extends ProductEvent {
  final String userId;

  const LoadProducts({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SaveProductChanges extends ProductEvent {
  final ProductModel updatedProduct;

  const SaveProductChanges({required this.updatedProduct});
  @override
  List<Object> get props => [updatedProduct];
}

class ProductImagePicked extends ProductEvent {
  final List<String> imagePaths;

  const ProductImagePicked({required this.imagePaths});
}

class DeleteProduct extends ProductEvent {
  final String userId;
  final String productId;
  final List<String> imageUrls;

  const DeleteProduct(
      {required this.productId, required this.imageUrls, required this.userId});

  @override
  List<Object> get props => [productId, imageUrls];
}

class ProductLoadFailed extends ProductEvent {
  final String errorMessage;
  const ProductLoadFailed({required this.errorMessage});
}

//add product page events:
class InitializeProductForm extends ProductEvent {}

class UpdateLocation extends ProductEvent {
  final LatLng pickedLocation;
  final String locationName;

  const UpdateLocation(
      {required this.pickedLocation, required this.locationName});

  @override
  List<Object> get props => [pickedLocation, locationName];
}

class UpdateImages extends ProductEvent {
  final List<String> imagePaths;

  const UpdateImages({required this.imagePaths});

  @override
  List<Object> get props => [imagePaths];
}

class UpdateTags extends ProductEvent {
  final List<String> tags;

  const UpdateTags({required this.tags});

  @override
  List<Object> get props => [tags];
}

class UpdateCategory extends ProductEvent {
  final CategoryModel selectedCategory;

  const UpdateCategory({required this.selectedCategory});

  @override
  List<Object> get props => [selectedCategory];
}

class UpdateFormFields extends ProductEvent {
  final Map<String, dynamic> formFields;

  const UpdateFormFields({required this.formFields});

  @override
  List<Object> get props => [formFields];
}

class UpdateAvailability extends ProductEvent {
  final bool isAvailable;
  const UpdateAvailability({required this.isAvailable});
  @override
  List<Object> get props => [isAvailable];
}
//update product page:

class InitializeProductFormWithData extends ProductEvent {
  final ProductModel product;
  const InitializeProductFormWithData(this.product);
  @override
  List<Object> get props => [product];
}
