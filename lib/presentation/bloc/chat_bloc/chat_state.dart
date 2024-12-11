part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatsLoading extends ChatState {}

final class ChatsWithDetailsLoaded extends ChatState {
  final List<Map<String, dynamic>> chatsWithDetails;

  const ChatsWithDetailsLoaded(this.chatsWithDetails);

  @override
  List<Object> get props => [chatsWithDetails];
}

final class MessagesLoading extends ChatState {}

final class MessagesLoaded extends ChatState {
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

final class ChatOperationSuccess extends ChatState {}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
