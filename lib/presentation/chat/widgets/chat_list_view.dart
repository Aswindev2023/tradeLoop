import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';

import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/chat/models/chat_model.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_list_tile.dart';

//Section for displaying list of chats user has:
class ChatListView extends StatelessWidget {
  final List<Map<String, dynamic>> chatsWithDetails;
  final String currentUserId;
  final Function(String chatId) onDeleteChat;

  const ChatListView({
    required this.chatsWithDetails,
    required this.currentUserId,
    required this.onDeleteChat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (chatsWithDetails.isEmpty) {
      return const Center(
        child: Text(
          "You don't have any messages yet.",
          style: TextStyle(fontSize: 16, color: grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: chatsWithDetails.length,
      itemBuilder: (context, index) {
        final chat = chatsWithDetails[index]['chat'] as ChatModel;
        final participants =
            chatsWithDetails[index]['participants'] as List<UserModel?>;

        final otherUser =
            participants.firstWhere((user) => user!.uid != currentUserId);
        //Section for each list tile for showing chats
        return ChatListTile(
          chat: chat,
          otherUser: otherUser!,
          currentUserId: currentUserId,
          onDeleteChat: onDeleteChat,
        );
      },
    );
  }
}
