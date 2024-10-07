part of 'auth_bloc_bloc.dart';

sealed class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthBlocEvent {
  final String email;
  final String password;
  const LoginButtonPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class SignUpButtonPressed extends AuthBlocEvent {
  final String name;
  final String email;
  final String password;
  const SignUpButtonPressed(
      {required this.name, required this.email, required this.password});
  @override
  List<Object> get props => [name, email, password];
}
