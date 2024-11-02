import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/repositories/products_service.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsService _productsService = ProductsService();
  ProductBloc() : super(ProductInitial()) {
    on<ProductAdded>((event, emit) async {
      emit(ProductLoading());
      try {
        await _productsService.addProduct(event.newProduct);
        emit(ProductAddedSuccess(newProduct: event.newProduct));
      } catch (e) {
        emit(ProductError(message: 'Failed to add product: $e'));
      }
    });

    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products =
            await _productsService.getProductsByUserId(event.userId);
        emit(ProductsLoaded(products: products));
      } catch (e) {
        emit(ProductError(message: 'Failed to load products: $e'));
      }
    });
  }
}
