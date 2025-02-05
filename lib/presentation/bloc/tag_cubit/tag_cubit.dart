import 'package:flutter_bloc/flutter_bloc.dart';

class TagCubit extends Cubit<List<String>> {
  TagCubit() : super([]);

  void addTag(String tag) {
    if (!state.contains(tag)) {
      emit([...state, tag]); // Creates a new list with the added tag
    }
  }

  void removeTag(String tag) {
    emit(state
        .where((t) => t != tag)
        .toList()); // Removes the tag and emits a new list
  }

  void initializeTags(List<String> tags) {
    emit(tags);
  }
}
