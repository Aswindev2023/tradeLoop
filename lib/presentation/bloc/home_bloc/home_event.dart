part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends HomeEvent {
  final String userId;

  const LoadProductsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
