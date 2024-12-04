part of 'wish_list_bloc.dart';

sealed class WishListState extends Equatable {
  const WishListState();

  @override
  List<Object> get props => [];
}

final class WishListInitial extends WishListState {}

class WishlistLoading extends WishListState {}

class WishlistLoaded extends WishListState {
  final List<HomePageProductModel> products;
  final List<String> productIds;

  const WishlistLoaded(this.products, this.productIds);

  @override
  List<Object> get props => [products];
}

class WishlistError extends WishListState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WishlistStatusChecked extends WishListState {
  final bool isInWishlist;
  final String productId;

  const WishlistStatusChecked(this.isInWishlist, this.productId);

  @override
  List<Object> get props => [isInWishlist, productId];
}
