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

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatPageDataLoaded extends ChatState {
  final String chatId;
  final String sellerName;
  final String? sellerImage;
  final bool isBanned;

  const ChatPageDataLoaded({
    required this.chatId,
    required this.sellerName,
    this.sellerImage,
    required this.isBanned,
  });

  @override
  List<Object> get props => [
        chatId,
        sellerName,
        sellerImage ?? 'https://robohash.org/placeholder?set=set4&size=200x200',
      ];
}
