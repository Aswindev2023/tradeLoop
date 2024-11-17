import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/repositories/home_services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeServices homeServices = HomeServices();
  HomeBloc() : super(HomeInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(HomePageLoading());
      try {
        final products =
            await homeServices.getProductsExcludingUserId(event.userId);
        emit(HomePageLoaded(products));
      } catch (e) {
        emit(HomePageError('Failed to load products: $e'));
        print('homepage error: $e');
      }
    });
    on<LoadCategoryProductsEvent>((event, emit) async {
      emit(HomePageLoading());
      try {
        final products = await homeServices.getCategorywiseProducts(
            event.userId, event.categoryId);
        emit(HomePageLoaded(products));
      } catch (e) {
        emit(HomePageError('Failed to load products by category: $e'));
        print('Category page error: $e');
      }
    });
    on<SearchProductsEvent>((event, emit) async {
      emit(HomePageLoading());
      try {
        final products = await homeServices.searchProducts(
          query: event.query,
          userId: event.userId,
          categoryId: event.categoryId,
          tags: event.tags,
        );
        emit(HomePageLoaded(products));
      } catch (e) {
        emit(HomePageError('Failed to search products: $e'));
        print('Search error: $e');
      }
    });
  }
}
