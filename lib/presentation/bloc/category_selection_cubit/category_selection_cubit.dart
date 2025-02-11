import 'package:bloc/bloc.dart';

class CategorySelectionCubit extends Cubit<String?> {
  CategorySelectionCubit() : super(null);

  void updateCategory(String? categoryId) {
    emit(categoryId);
  }
}
