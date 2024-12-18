import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/screens/chat_list_page.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_app_bar.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_message_section.dart';

class ChatPage extends StatelessWidget {
  final String sellerId;
  final String currentUserId;

  const ChatPage({
    required this.sellerId,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(LoadChatPageDataEvent(
        currentUserId: currentUserId, sellerId: sellerId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            context
                .read<ChatBloc>()
                .add(CreateChatEvent(currentUserId, sellerId, ''));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChatListPage()),
              (route) => false,
            );
          },
        ),
        title: const ChatAppBar(),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatPageDataLoaded) {
            return ChatMessagesSection(
              currentUserId: currentUserId,
              chatId: state.chatId,
            );
          } else if (state is ChatError) {
            return const Center(
              child: Text(
                'Failed to load chat. Please try again.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
