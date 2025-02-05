import 'package:bloc/bloc.dart';

class BoolCubit extends Cubit<bool> {
  BoolCubit() : super(false);

  void updateSearchState(String query) {
    emit(query.isNotEmpty);
  }

  void setLoading(bool isLoading) {
    emit(isLoading);
  }
}
