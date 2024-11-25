part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  const FetchProductDetailsEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
