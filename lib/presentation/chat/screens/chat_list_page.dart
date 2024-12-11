import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/models/chat_model.dart';
import 'package:trade_loop/presentation/chat/screens/chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsWithDetailsLoaded) {
            final chats = state.chatsWithDetails;

            if (chats.isEmpty) {
              return const Center(
                child: Text(
                  "You don't have any messages yet.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index]['chat'] as ChatModel;
                final participants =
                    chats[index]['participants'] as List<UserModel>;

                final otherUser = participants
                    .firstWhere((user) => user.uid != chat.participants[0]);
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(otherUser.imagePath ?? ''),
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
                  trailing: Text(_formatTimestamp(chat.lastMessageTime)),
                  onTap: () {
                    final currentUserId =
                        FirebaseAuth.instance.currentUser?.uid ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userName: otherUser.name,
                          profileImage: otherUser.imagePath ?? '',
                          chatId: chat.chatId,
                          currentUserId: currentUserId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatError) {
            return const Center(
              child: Text(
                "Failed to load chats. Please try again.",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          // Default empty state
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format the timestamp to a readable format, e.g., '2 mins ago'
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}
