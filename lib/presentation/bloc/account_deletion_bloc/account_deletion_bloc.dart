import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/repositories/account_deletion_service.dart';

part 'account_deletion_event.dart';
part 'account_deletion_state.dart';

class AccountDeletionBloc
    extends Bloc<AccountDeletionEvent, AccountDeletionState> {
  final AccountDeletionService accountDeletionService =
      AccountDeletionService();
  AccountDeletionBloc() : super(AccountDeletionInitial()) {
    //Delete User Account
    on<DeleteAccountRequested>((event, emit) async {
      emit(DeleteAccountInProgress());
      try {
        await accountDeletionService.deleteUserAccount(
          event.userId,
        );
        emit(DeleteAccountSuccess());
      } catch (e) {
        emit(DeleteAccountFailure(e.toString()));
      }
    });
    //Re-authentication bloc
    on<ReauthenticateWithEmailPassword>((event, emit) async {
      emit(DeleteAccountInProgress());
      try {
        await accountDeletionService.reauthenticateWithEmail(
            event.email, event.password);
        emit(ReauthenticationSuccess());
      } catch (e) {
        emit(DeleteAccountFailure('Reauthentication failed: ${e.toString()}'));
      }
    });

    //Google re-authentication
    on<ReauthenticateWithGoogle>((event, emit) async {
      emit(DeleteAccountInProgress());
      try {
        await accountDeletionService.reauthenticateWithGoogle();
        emit(ReauthenticationSuccess());
      } catch (e) {
        emit(ReauthenticationFailure(
            'Reauthentication failed: ${e.toString()}'));
      }
    });
  }
}
