part of 'account_delete_bloc.dart';

sealed class AccountDeleteState extends Equatable {
  const AccountDeleteState();

  @override
  List<Object> get props => [];
}

final class AccountDeleteInitial extends AccountDeleteState {}

class AccountDeletionInProgress extends AccountDeleteState {}

class AccountDeletionSuccess extends AccountDeleteState {}

class AccountDeletionFailure extends AccountDeleteState {
  final String error;

  const AccountDeletionFailure(this.error);

  @override
  List<Object> get props => [error];
}
