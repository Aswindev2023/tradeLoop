import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';

class ChatMessagesSection extends StatefulWidget {
  final String currentUserId;
  final String chatId;
  final bool isBanned;

  const ChatMessagesSection({
    required this.currentUserId,
    required this.chatId,
    required this.isBanned,
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
                      style: TextStyle(fontSize: 16, color: grey),
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

                    // Determine if the date separator is needed
                    final DateTime currentMessageDate = message.timestamp;
                    final bool showDateSeparator = index == 0 ||
                        currentMessageDate.day !=
                            messages[index - 1].timestamp.day ||
                        currentMessageDate.month !=
                            messages[index - 1].timestamp.month ||
                        currentMessageDate.year !=
                            messages[index - 1].timestamp.year;

                    // Format the date as a readable string
                    final date = DateFormat('EEEE, MMMM d, yyyy')
                        .format(currentMessageDate);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display the date separator if required
                        if (showDateSeparator)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              date,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: grey600,
                              ),
                            ),
                          ),

                        // The actual message tile with deletion functionality
                        Dismissible(
                          key: Key(message.messageId),
                          direction: isSentByUser
                              ? DismissDirection.endToStart
                              : DismissDirection.none,
                          onDismissed: (direction) {
                            context.read<MessageBloc>().add(
                                  DeleteMessagesEvent(
                                    widget.chatId,
                                    message.messageId,
                                  ),
                                );
                            SnackbarUtils.showSnackbar(
                                context, 'Message deleted');
                          },
                          background: Container(
                            color: red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: whiteColor),
                          ),
                          child: Align(
                            alignment: isSentByUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSentByUser ? blue100 : grey200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.content,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    DateFormat('hh:mm a')
                                        .format(currentMessageDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: grey600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is MessageError) {
                return const Center(
                  child: Text(
                    "Failed to load messages. Please try again.",
                    style: TextStyle(fontSize: 16, color: red),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),

        // Message Input
        if (widget.isBanned)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomTextWidget(
              text: "This user is banned. You cannot send messages.",
              fontSize: 16.0,
              color: red,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: grey100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    maxLines: null,
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: messageInputCol,
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
                    icon: const Icon(Icons.send, color: whiteColor),
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
