part of 'auth_bloc_bloc.dart';

sealed class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object> get props => [];
}

final class AuthBlocInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class AuthSuccess extends AuthBlocState {}

class AuthFailure extends AuthBlocState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class PasswordResetSuccess extends AuthBlocState {}

class PasswordResetFailure extends AuthBlocState {
  final String message;

  const PasswordResetFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLoggedOut extends AuthBlocState {}
