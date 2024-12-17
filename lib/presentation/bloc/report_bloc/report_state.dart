part of 'report_bloc.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

class ReportSubmitting extends ReportState {}

class ReportSubmittedSuccess extends ReportState {}

class ReportSubmittedFailure extends ReportState {
  final String errorMessage;

  const ReportSubmittedFailure(this.errorMessage);
}
