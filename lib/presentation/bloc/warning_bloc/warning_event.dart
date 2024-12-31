part of 'warning_bloc.dart';

sealed class WarningEvent extends Equatable {
  const WarningEvent();

  @override
  List<Object> get props => [];
}

class FetchWarningsEvent extends WarningEvent {
  final String userId;

  const FetchWarningsEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}
