part of 'seller_profile_bloc.dart';

sealed class SellerProfileState extends Equatable {
  const SellerProfileState();

  @override
  List<Object> get props => [];
}

final class SellerProfileInitial extends SellerProfileState {}

final class SellerProfileLoading extends SellerProfileState {}

final class SellerProfileLoaded extends SellerProfileState {
  final UserModel seller;
  final List<HomePageProductModel> products;

  const SellerProfileLoaded({required this.seller, required this.products});

  @override
  List<Object> get props => [seller, products];
}

final class SellerProfileError extends SellerProfileState {
  final String message;

  const SellerProfileError(this.message);

  @override
  List<Object> get props => [message];
}
