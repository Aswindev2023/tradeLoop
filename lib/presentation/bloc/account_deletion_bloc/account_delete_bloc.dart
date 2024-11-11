import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/repositories/account_deletion_service.dart';

part 'account_delete_event.dart';
part 'account_delete_state.dart';

class AccountDeleteBloc extends Bloc<AccountDeleteEvent, AccountDeleteState> {
  final AccountDeletionService accountDeletionService =
      AccountDeletionService();

  AccountDeleteBloc() : super(AccountDeleteInitial()) {
    on<DeleteUserProductsEvent>((event, emit) async {
      emit(AccountDeletionInProgress());
      try {
        await accountDeletionService.deleteUserProducts(event.userId);
        emit(AccountDeleteInitial());
      } catch (e) {
        emit(AccountDeletionFailure("Failed to delete user products: $e"));
      }
    });
    on<DeleteUserAccountEvent>((event, emit) async {
      emit(AccountDeletionInProgress());
      try {
        await accountDeletionService.deleteUserAccount(event.userId);
        emit(AccountDeletionSuccess());
      } catch (e) {
        emit(AccountDeletionFailure("Failed to delete user account: $e"));
      }
    });
  }
}
