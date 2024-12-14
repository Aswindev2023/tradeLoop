import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/format_timestamp.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/chat/models/chat_model.dart';
import 'package:trade_loop/presentation/chat/screens/chat_page.dart';

class ChatListView extends StatelessWidget {
  final List<Map<String, dynamic>> chatsWithDetails;
  final String currentUserId;

  const ChatListView({
    required this.chatsWithDetails,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (chatsWithDetails.isEmpty) {
      return const Center(
        child: Text(
          "You don't have any messages yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
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

        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(otherUser!.imagePath ??
                'https://robohash.org/placeholder?set=set4&size=200x200'),
          ),
          title: Text(
            otherUser.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            chat.lastMessage ?? 'No messages yet',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(formatTimestamp(chat.lastMessageTime)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  sellerId: otherUser.uid!,
                  currentUserId: currentUserId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
