import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/profile/model/warning_message_model.dart';
import 'package:trade_loop/repositories/warning_services.dart';

part 'warning_event.dart';
part 'warning_state.dart';

class WarningBloc extends Bloc<WarningEvent, WarningState> {
  WarningServices warningServices = WarningServices();
  WarningBloc() : super(WarningInitial()) {
    on<FetchWarningsEvent>((event, emit) async {
      emit(WarningLoading());
      try {
        final warnings = await warningServices.fetchWarnings(event.userId);
        print('loaded warnings are: $warnings');
        emit(WarningLoaded(warnings: warnings));
      } catch (e) {
        emit(WarningError(message: e.toString()));
      }
    });
  }
}
