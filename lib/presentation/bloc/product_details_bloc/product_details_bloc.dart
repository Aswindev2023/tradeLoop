import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/repositories/products_service.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductsService productsService = ProductsService();

  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    //Fetch products details
    on<FetchProductDetailsEvent>((event, emit) async {
      emit(ProductDetailsLoading());
      try {
        final product =
            await productsService.getProductDetailsById(event.productId);
        emit(ProductDetailsLoaded(product!));
      } catch (error) {
        emit(ProductDetailsError(error.toString()));
      }
    });
  }
}
