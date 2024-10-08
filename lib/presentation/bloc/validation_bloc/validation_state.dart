part of 'validation_bloc.dart';

sealed class ValidationState extends Equatable {
  const ValidationState();

  @override
  List<Object> get props => [];
}

final class ValidationInitial extends ValidationState {}

final class ValidationSuccess extends ValidationState {}

final class ValidationError extends ValidationState {
  final String message;

  const ValidationError(this.message);

  @override
  List<Object> get props => [message];
}
