import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/repositories/chat_services.dart';
import 'package:trade_loop/repositories/user_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices chatService = ChatServices();
  final UserRepository userRepository = UserRepository();
  ChatBloc() : super(ChatInitial()) {
    on<FetchUserChatsEvent>((event, emit) async {
      emit(ChatsLoading());
      try {
        final chatsWithDetails =
            await chatService.fetchChatsWithUserDetails(event.userId);
        print('fetching chats with details:$chatsWithDetails');
        emit(ChatsWithDetailsLoaded(chatsWithDetails));
      } catch (e) {
        emit(ChatError("Failed to fetch chats: $e"));
      }
    });

    on<CreateChatEvent>((event, emit) async {
      try {
        await chatService.createChat(
          event.userId1,
          event.userId2,
          event.initialMessage,
        );
        print('create chat is successfull');
      } catch (e) {
        emit(ChatError("Failed to create chat: $e"));
      }
    });

    on<LoadChatPageDataEvent>((event, emit) async {
      emit(ChatsLoading());
      try {
        final seller = await userRepository.getUser(event.sellerId);

        if (seller == null) {
          throw Exception("Seller not found");
        }

        final chatId = await chatService.createChat(
          event.currentUserId,
          event.sellerId,
          "",
        );

        emit(ChatPageDataLoaded(
          chatId: chatId,
          sellerName: seller.name,
          sellerImage: seller.imagePath,
        ));
      } catch (e) {
        emit(ChatError("Failed to load chat page data: $e"));
      }
    });
    on<DeleteChatEvent>((event, emit) async {
      try {
        emit(ChatsLoading());
        await chatService.deleteChat(event.chatId);
        print('Chat deleted successfully');

        final updatedChats =
            await chatService.fetchChatsWithUserDetails(event.chatId);
        emit(ChatsWithDetailsLoaded(updatedChats));
      } catch (e) {
        emit(ChatError("Failed to delete chat: $e"));
      }
    });
  }
}
