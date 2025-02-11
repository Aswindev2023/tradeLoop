import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';
import 'package:trade_loop/repositories/chat_services.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatServices chatService = ChatServices();

  MessageBloc() : super(MessageInitial()) {
    //fetch user's messages
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
        emit(MessageError("Failed to fetch messages: $e"));
      }
    });
    //Send messages
    on<SendMessageEvent>((event, emit) async {
      try {
        await chatService.sendMessage(event.chatId, event.message);
      } catch (e) {
        emit(MessageError("Failed to send message: $e"));
      }
    });
    //Delete messages
    on<DeleteMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      try {
        await chatService.deleteMessage(event.chatId, event.messageIds);
      } catch (e) {
        emit(MessageError("Failed to delete messages: $e"));
      }
    });
  }
}
