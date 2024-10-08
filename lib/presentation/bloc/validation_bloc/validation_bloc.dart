import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationInitial()) {
    on<ValidateEmail>((event, emit) {
      if (event.email.isEmpty) {
        emit(const ValidationError("Email can't be empty"));
      } else {
        emit(ValidationSuccess());
      }
    });
    on<ValidatePassword>((event, emit) {
      if (event.password.isEmpty) {
        emit(const ValidationError("Password can't be empty"));
      } else {
        emit(ValidationSuccess());
      }
    });
    on<ValidateName>((event, emit) {
      if (event.name.isEmpty) {
        emit(const ValidationError("Name can't be empty"));
      } else {
        emit(ValidationSuccess());
      }
    });
  }
}
