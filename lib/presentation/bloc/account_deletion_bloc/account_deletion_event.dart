part of 'account_deletion_bloc.dart';

sealed class AccountDeletionEvent extends Equatable {
  const AccountDeletionEvent();

  @override
  List<Object> get props => [];
}

class DeleteAccountRequested extends AccountDeletionEvent {
  final String userId;

  const DeleteAccountRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class ReauthenticateWithEmailPassword extends AccountDeletionEvent {
  final String email;
  final String password;

  const ReauthenticateWithEmailPassword(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class ReauthenticateWithGoogle extends AccountDeletionEvent {}
