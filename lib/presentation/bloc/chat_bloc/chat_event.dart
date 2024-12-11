part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class FetchUserChatsEvent extends ChatEvent {
  final String userId;

  const FetchUserChatsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

final class FetchMessagesEvent extends ChatEvent {
  final String chatId;

  const FetchMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

final class SendMessageEvent extends ChatEvent {
  final String chatId;
  final MessageModel message;

  const SendMessageEvent({required this.chatId, required this.message});

  @override
  List<Object> get props => [chatId, message];
}

final class CreateChatEvent extends ChatEvent {
  final String userId1;
  final String userId2;
  final String initialMessage;

  const CreateChatEvent(this.userId1, this.userId2, this.initialMessage);

  @override
  List<Object> get props => [userId1, userId2, initialMessage];
}
