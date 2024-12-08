import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/repositories/seller_service.dart';

part 'seller_profile_event.dart';
part 'seller_profile_state.dart';

class SellerProfileBloc extends Bloc<SellerProfileEvent, SellerProfileState> {
  final SellerService sellerService = SellerService();
  SellerProfileBloc() : super(SellerProfileInitial()) {
    on<FetchSellerProfile>((event, emit) async {
      emit(SellerProfileLoading());
      try {
        final user = await sellerService.getUserById(event.sellerId);
        final products =
            await sellerService.getProductsByUserId(event.sellerId);
        emit(SellerProfileLoaded(seller: user!, products: products));
      } catch (e) {
        emit(const SellerProfileError('Failed to load Seller Profile'));
        print('failed to load seller profile:$e');
      }
    });
  }
}
