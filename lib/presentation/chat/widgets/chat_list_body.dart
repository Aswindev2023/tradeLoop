import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_list_view.dart';

class ChatListBody extends StatelessWidget {
  final String currentUserId;
  const ChatListBody({required this.currentUserId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatsWithDetailsLoaded) {
          return ChatListView(
            chatsWithDetails: state.chatsWithDetails,
            currentUserId: currentUserId,
            onDeleteChat: (String chatId) {
              context.read<ChatBloc>().add(DeleteChatEvent(chatId));
            },
          );
        } else if (state is ChatError) {
          return const Center(
            child: Text(
              "Failed to load chats. Please try again.",
              style: TextStyle(fontSize: 16, color: red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
