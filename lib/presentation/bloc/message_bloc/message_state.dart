part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessagesLoading extends MessageState {}

final class MessagesLoaded extends MessageState {
  final List<MessageModel> messages;
  final bool isFirstTime;
  final DateTime timestamp;

  const MessagesLoaded({
    required this.messages,
    this.isFirstTime = false,
    required this.timestamp,
  });

  @override
  List<Object> get props => [messages, isFirstTime, timestamp];
}

final class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}
