part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

class HomePageLoading extends HomeState {}

class HomePageLoaded extends HomeState {
  final List<HomePageProductModel> products;

  const HomePageLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class HomePageError extends HomeState {
  final String message;

  const HomePageError(this.message);

  @override
  List<Object> get props => [message];
}
