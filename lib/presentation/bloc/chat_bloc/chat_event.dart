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

final class CreateChatEvent extends ChatEvent {
  final String userId1;
  final String userId2;
  final String initialMessage;

  const CreateChatEvent(this.userId1, this.userId2, this.initialMessage);

  @override
  List<Object> get props => [userId1, userId2, initialMessage];
}

final class LoadChatPageDataEvent extends ChatEvent {
  final String currentUserId;
  final String sellerId;

  const LoadChatPageDataEvent({
    required this.currentUserId,
    required this.sellerId,
  });

  @override
  List<Object> get props => [currentUserId, sellerId];
}
