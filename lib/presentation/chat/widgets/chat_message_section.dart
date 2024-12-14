import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';

class ChatMessagesSection extends StatefulWidget {
  final String currentUserId;
  final String chatId;

  const ChatMessagesSection({
    required this.currentUserId,
    required this.chatId,
    super.key,
  });

  @override
  State<ChatMessagesSection> createState() => _ChatMessagesSectionState();
}

class _ChatMessagesSectionState extends State<ChatMessagesSection> {
  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(FetchMessagesEvent(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Column(
      children: [
        // Message List
        Expanded(
          child: BlocBuilder<MessageBloc, MessageState>(
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
                    final isSentByUser =
                        message.senderId == widget.currentUserId;
                    return Dismissible(
                      key: Key(message.messageId),
                      direction: isSentByUser
                          ? DismissDirection
                              .endToStart // Allow delete only for user's messages
                          : DismissDirection
                              .none, // No swipe for other users' messages
                      onDismissed: (direction) {
                        context.read<MessageBloc>().add(
                              DeleteMessagesEvent(
                                widget.chatId,
                                message.messageId,
                              ),
                            );
                        SnackbarUtils.showSnackbar(context, 'Message deleted');
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Align(
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
                      ),
                    );
                  },
                );
              } else if (state is MessageError) {
                return const Center(
                  child: Text(
                    "Failed to load messages. Please try again.",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              }

              // Default empty state
              return const SizedBox.shrink();
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Colors.grey[100],
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 207, 206, 206),
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
                backgroundColor: appbarColor,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    final value = messageController.text.trim();
                    if (value.isNotEmpty) {
                      context.read<MessageBloc>().add(
                            SendMessageEvent(
                              chatId: widget.chatId,
                              message: MessageModel(
                                messageId: DateTime.now().toString(),
                                senderId: widget.currentUserId,
                                content: value,
                                timestamp: DateTime.now(),
                                type: "text",
                              ),
                            ),
                          );
                      messageController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
