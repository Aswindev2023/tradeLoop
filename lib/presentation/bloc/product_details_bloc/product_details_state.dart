part of 'product_details_bloc.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;
  const ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String error;
  const ProductDetailsError(this.error);
}
