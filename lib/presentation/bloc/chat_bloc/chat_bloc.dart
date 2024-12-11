import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';
import 'package:trade_loop/repositories/chat_services.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices chatService = ChatServices();
  ChatBloc() : super(ChatInitial()) {
    on<FetchUserChatsEvent>((event, emit) async {
      emit(ChatsLoading());
      try {
        final chatsWithDetails =
            await chatService.fetchChatsWithUserDetails(event.userId);
        emit(ChatsWithDetailsLoaded(chatsWithDetails));
      } catch (e) {
        emit(ChatError("Failed to fetch chats: $e"));
      }
    });

    on<FetchMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      try {
        final messageStream = chatService.getMessages(event.chatId);
        await emit.forEach(messageStream,
            onData: (List<MessageModel> messages) {
          final isFirstTime = messages.isEmpty;
          final timestamp = DateTime.now();
          return MessagesLoaded(
            messages: messages,
            isFirstTime: isFirstTime,
            timestamp: timestamp,
          );
        });
      } catch (e) {
        emit(ChatError("Failed to fetch messages: $e"));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await chatService.sendMessage(event.chatId, event.message);
        emit(ChatOperationSuccess());
      } catch (e) {
        emit(ChatError("Failed to send message: $e"));
      }
    });

    on<CreateChatEvent>((event, emit) async {
      try {
        await chatService.createChat(
            event.userId1, event.userId2, event.initialMessage);
        emit(ChatOperationSuccess());
      } catch (e) {
        emit(ChatError("Failed to create chat: $e"));
      }
    });
  }
}
