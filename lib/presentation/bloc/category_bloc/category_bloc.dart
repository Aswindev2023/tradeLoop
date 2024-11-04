import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';
import 'package:trade_loop/repositories/user_category_service.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final UserCategoryService categoryService = UserCategoryService();
  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await categoryService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError('Failed to fetch categories'));
      }
    });
  }
}
