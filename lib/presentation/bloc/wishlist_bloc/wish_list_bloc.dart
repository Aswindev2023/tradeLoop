import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/repositories/wishlist_services.dart';

part 'wish_list_event.dart';
part 'wish_list_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishlistServices wishlistServices = WishlistServices();
  WishListBloc() : super(WishListInitial()) {
    on<FetchWishlistEvent>((event, emit) async {
      emit(WishlistLoading());
      try {
        final products = await wishlistServices.fetchWishlist(event.userId);
        final productIds =
            products.map((product) => product.productId).toList();
        emit(WishlistLoaded(products, productIds));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<AddProductToWishlistEvent>((event, emit) async {
      try {
        await wishlistServices.addProductToWishlist(
            event.userId, event.productId);
        add(FetchWishlistEvent(event.userId));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
    on<RemoveProductFromWishlistEvent>((event, emit) async {
      try {
        await wishlistServices.removeProductFromWishlist(
            event.userId, event.productId);
        add(FetchWishlistEvent(event.userId));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
  }
}
