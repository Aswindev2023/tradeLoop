part of 'recently_viewed_bloc.dart';

sealed class RecentlyViewedEvent extends Equatable {
  const RecentlyViewedEvent();

  @override
  List<Object> get props => [];
}

class AddRecentlyViewed extends RecentlyViewedEvent {
  final String productId;
  final String userId;
  const AddRecentlyViewed(this.productId, this.userId);
}

class FetchRecentlyViewed extends RecentlyViewedEvent {
  final String userId;
  const FetchRecentlyViewed(this.userId);
}
