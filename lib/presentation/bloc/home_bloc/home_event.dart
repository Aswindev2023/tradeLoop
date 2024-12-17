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

class LoadCategoryProductsEvent extends HomeEvent {
  final String userId;
  final String categoryId;

  const LoadCategoryProductsEvent(this.userId, this.categoryId);

  @override
  List<Object> get props => [userId, categoryId];
}

class SearchProductsEvent extends HomeEvent {
  final String query;
  final String userId;
  final List<String>? categoryId;
  final List<String>? tags;
  final List<Map<String, dynamic>>? priceRanges;

  const SearchProductsEvent({
    required this.query,
    required this.userId,
    this.categoryId,
    this.tags,
    this.priceRanges,
  });

  @override
  List<Object> get props => [query, userId, categoryId!, tags!, priceRanges!];
}
