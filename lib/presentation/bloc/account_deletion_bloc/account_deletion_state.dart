part of 'account_deletion_bloc.dart';

sealed class AccountDeletionState extends Equatable {
  const AccountDeletionState();

  @override
  List<Object> get props => [];
}

final class AccountDeletionInitial extends AccountDeletionState {}

class DeleteAccountInProgress extends AccountDeletionState {}

class DeleteAccountSuccess extends AccountDeletionState {}

class DeleteAccountFailure extends AccountDeletionState {
  final String errorMessage;

  const DeleteAccountFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ReauthenticationSuccess extends AccountDeletionState {}

class ReauthenticationFailure extends AccountDeletionState {
  final String errorMessage;

  const ReauthenticationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
