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

class EditProductPressed extends ProductEvent {}

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
  final String productId;
  const DeleteProduct({required this.productId});
}

class ProductLoadFailed extends ProductEvent {
  final String errorMessage;
  const ProductLoadFailed({required this.errorMessage});
}

class ProductFormUpdated extends ProductEvent {
  final ProductFormState formState;

  const ProductFormUpdated({required this.formState});

  @override
  List<Object> get props => [formState];
}

class ToggleLoading extends ProductEvent {
  final bool isLoading;

  const ToggleLoading({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}

class UpdatePickedLocation extends ProductEvent {
  final LatLng pickedLocation;
  final String locationName;

  const UpdatePickedLocation({
    required this.pickedLocation,
    required this.locationName,
  });

  @override
  List<Object> get props => [pickedLocation, locationName];
}
