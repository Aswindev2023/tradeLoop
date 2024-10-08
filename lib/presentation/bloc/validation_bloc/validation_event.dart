part of 'validation_bloc.dart';

sealed class ValidationEvent extends Equatable {
  const ValidationEvent();

  @override
  List<Object> get props => [];
}

final class ValidateEmail extends ValidationEvent {
  final String email;

  const ValidateEmail(this.email);

  @override
  List<Object> get props => [email];
}

final class ValidatePassword extends ValidationEvent {
  final String password;

  const ValidatePassword(this.password);

  @override
  List<Object> get props => [password];
}

final class ValidateName extends ValidationEvent {
  final String name;

  const ValidateName(this.name);

  @override
  List<Object> get props => [name];
}
