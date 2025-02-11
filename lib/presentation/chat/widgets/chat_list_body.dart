import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_list_view.dart';

class ChatListBody extends StatefulWidget {
  final String currentUserId;
  const ChatListBody({required this.currentUserId, super.key});

  @override
  State<ChatListBody> createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  void _fetchChats() {
    context.read<ChatBloc>().add(FetchUserChatsEvent(widget.currentUserId));
  }

  void _deleteChat(String chatId) {
    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(DeleteChatEvent(chatId));

    // Ensure the list is refetched after deletion
    Future.delayed(const Duration(milliseconds: 300), () {
      _fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatsWithDetailsLoaded) {
          return ChatListView(
            chatsWithDetails: state.chatsWithDetails,
            currentUserId: widget.currentUserId,
            onDeleteChat: _deleteChat,
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
