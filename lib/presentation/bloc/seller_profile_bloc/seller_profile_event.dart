part of 'seller_profile_bloc.dart';

sealed class SellerProfileEvent extends Equatable {
  const SellerProfileEvent();

  @override
  List<Object> get props => [];
}

final class FetchSellerProfile extends SellerProfileEvent {
  final String sellerId;

  const FetchSellerProfile(this.sellerId);

  @override
  List<Object> get props => [sellerId];
}
