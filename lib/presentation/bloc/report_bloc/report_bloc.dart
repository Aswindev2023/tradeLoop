import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/report/model/report_model.dart';
import 'package:trade_loop/repositories/report_service.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService _reportService = ReportService();
  ReportBloc() : super(ReportInitial()) {
    on<SubmitReportEvent>((event, emit) async {
      emit(ReportSubmitting());
      try {
        await _reportService.submitReport(event.report);
        emit(ReportSubmittedSuccess());
      } catch (e) {
        emit(ReportSubmittedFailure(e.toString()));
      }
    });
  }
}
