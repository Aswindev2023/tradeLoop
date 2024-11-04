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

class ProductFormState extends ProductState {
  final String name;
  final String description;
  final String price;
  final String condition;
  final List<String> imageUrls;
  final List<String> tags;
  final bool isAvailable;

  const ProductFormState({
    this.name = '',
    this.description = '',
    this.price = '',
    this.condition = '',
    this.imageUrls = const [],
    this.tags = const [],
    this.isAvailable = true,
  });
}
