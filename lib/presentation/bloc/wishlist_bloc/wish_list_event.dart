part of 'wish_list_bloc.dart';

sealed class WishListEvent extends Equatable {
  const WishListEvent();

  @override
  List<Object> get props => [];
}

class FetchWishlistEvent extends WishListEvent {
  final String userId;

  const FetchWishlistEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddProductToWishlistEvent extends WishListEvent {
  final String userId;
  final String productId;

  const AddProductToWishlistEvent(this.userId, this.productId);

  @override
  List<Object> get props => [userId, productId];
}

class RemoveProductFromWishlistEvent extends WishListEvent {
  final String userId;
  final String productId;

  const RemoveProductFromWishlistEvent(this.userId, this.productId);

  @override
  List<Object> get props => [userId, productId];
}

class CheckWishlistStatusEvent extends WishListEvent {
  final String userId;
  final String productId;

  const CheckWishlistStatusEvent(this.userId, this.productId);

  @override
  List<Object> get props => [userId, productId];
}
