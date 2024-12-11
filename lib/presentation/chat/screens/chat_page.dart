import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';

class ChatPage extends StatelessWidget {
  final String userName;
  final String profileImage;
  final String chatId;
  final String currentUserId;

  ChatPage({
    required this.userName,
    required this.profileImage,
    required this.chatId,
    required this.currentUserId,
    super.key,
  });

  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(width: 10),
            Text(userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet. Say hello!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSentByUser = message.senderId == currentUserId;
                      return Align(
                        alignment: isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return const Center(
                    child: Text(
                      "Failed to load messages. Please try again.",
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }

                // Default empty state
                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final value = _messageController.text.trim();
                      if (value.isNotEmpty) {
                        final messageId = FirebaseFirestore.instance
                            .collection('messages')
                            .doc()
                            .id;
                        final newMessage = MessageModel(
                          messageId: messageId,
                          senderId: currentUserId,
                          content: value,
                          timestamp: DateTime.now(),
                          type: "text",
                        );
                        context.read<ChatBloc>().add(
                              SendMessageEvent(
                                  chatId: chatId, message: newMessage),
                            );
                        _messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
