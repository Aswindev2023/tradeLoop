part of 'warning_bloc.dart';

sealed class WarningState extends Equatable {
  const WarningState();

  @override
  List<Object> get props => [];
}

final class WarningInitial extends WarningState {}

class WarningLoading extends WarningState {}

class WarningLoaded extends WarningState {
  final List<WarningMessageModel> warnings;

  const WarningLoaded({required this.warnings});
  @override
  List<Object> get props => [warnings];
}

class WarningError extends WarningState {
  final String message;

  const WarningError({required this.message});
  @override
  List<Object> get props => [message];
}
