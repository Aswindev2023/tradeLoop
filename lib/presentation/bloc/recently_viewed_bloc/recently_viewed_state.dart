part of 'recently_viewed_bloc.dart';

sealed class RecentlyViewedState extends Equatable {
  const RecentlyViewedState();

  @override
  List<Object> get props => [];
}

final class RecentlyViewedInitial extends RecentlyViewedState {}

final class RecentlyViewedAdded extends RecentlyViewedState {}

class RecentlyViewedLoading extends RecentlyViewedState {}

class RecentlyViewedLoaded extends RecentlyViewedState {
  final List<HomePageProductModel> products;
  const RecentlyViewedLoaded(this.products);
}

class RecentlyViewedError extends RecentlyViewedState {
  final String message;
  const RecentlyViewedError(this.message);
}
