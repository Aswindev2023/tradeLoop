import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/repositories/recently_viewed_service.dart';

part 'recently_viewed_event.dart';
part 'recently_viewed_state.dart';

class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final RecentlyViewedService _service = RecentlyViewedService();

  RecentlyViewedBloc() : super(RecentlyViewedInitial()) {
    //Add products to recently viewed list
    on<AddRecentlyViewed>((event, emit) async {
      try {
        await _service.addRecentlyViewedProduct(event.userId, event.productId);

        emit(RecentlyViewedAdded());
      } catch (e) {
        emit(const RecentlyViewedError(
            'Failed to add recently viewed products'));
      }
    });
    //Fetch recently viewed products
    on<FetchRecentlyViewed>((event, emit) async {
      emit(RecentlyViewedLoading());
      try {
        final List<HomePageProductModel> products =
            await _service.getRecentlyViewedProducts(event.userId);

        emit(RecentlyViewedLoaded(products));
      } catch (e) {
        emit(const RecentlyViewedError(
            'Failed to load recently viewed products'));
      }
    });
  }
}
