part of 'account_delete_bloc.dart';

sealed class AccountDeleteEvent extends Equatable {
  const AccountDeleteEvent();

  @override
  List<Object> get props => [];
}

class DeleteUserProductsEvent extends AccountDeleteEvent {
  final String userId;

  const DeleteUserProductsEvent(this.userId);
}

class DeleteUserAccountEvent extends AccountDeleteEvent {
  final String userId;

  const DeleteUserAccountEvent(this.userId);
}

class CompleteAccountDeletionEvent extends AccountDeleteEvent {}
