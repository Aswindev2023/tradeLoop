import 'package:bloc/bloc.dart';

class ImageSliderCubit extends Cubit<int> {
  ImageSliderCubit() : super(0);

  void updateIndex(int index) => emit(index);
}
