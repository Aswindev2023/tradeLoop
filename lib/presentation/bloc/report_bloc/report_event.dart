part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitReportEvent extends ReportEvent {
  final ReportModel report;

  const SubmitReportEvent(this.report);
}
