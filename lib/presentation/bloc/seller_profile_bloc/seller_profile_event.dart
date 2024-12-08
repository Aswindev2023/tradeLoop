part of 'seller_profile_bloc.dart';

sealed class SellerProfileEvent extends Equatable {
  const SellerProfileEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch seller profile details
final class FetchSellerProfile extends SellerProfileEvent {
  final String sellerId;

  const FetchSellerProfile(this.sellerId);

  @override
  List<Object> get props => [sellerId];
}
