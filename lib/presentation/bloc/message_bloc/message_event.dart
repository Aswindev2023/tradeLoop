part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

final class FetchMessagesEvent extends MessageEvent {
  final String chatId;

  const FetchMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

final class SendMessageEvent extends MessageEvent {
  final String chatId;
  final MessageModel message;

  const SendMessageEvent({required this.chatId, required this.message});

  @override
  List<Object> get props => [chatId, message];
}

class DeleteMessagesEvent extends MessageEvent {
  final String chatId;
  final String messageIds;

  const DeleteMessagesEvent(this.chatId, this.messageIds);

  @override
  List<Object> get props => [chatId, messageIds];
}
