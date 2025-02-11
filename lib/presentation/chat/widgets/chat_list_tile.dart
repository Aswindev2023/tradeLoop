import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/format_timestamp.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/authentication/widgets/confirmation_dialog.dart';
import 'package:trade_loop/presentation/chat/models/chat_model.dart';
import 'package:trade_loop/presentation/chat/screens/chat_page.dart';

class ChatListTile extends StatelessWidget {
  final ChatModel chat;
  final UserModel otherUser;
  final String currentUserId;
  final Function(String chatId) onDeleteChat;

  const ChatListTile({
    required this.chat,
    required this.otherUser,
    required this.currentUserId,
    required this.onDeleteChat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chat.chatId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: red,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: whiteColor),
      ),
      //Delete chat
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: 'Delete Chat',
            content: 'Are you sure you want to delete this chat?',
            onConfirm: () {
              onDeleteChat(chat.chatId);

              SnackbarUtils.showSnackbar(context, 'Chat Deleted Sucessfully.');
            },
          ),
        );
      },
      child: ListTile(
        //Display seller's profile image
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(otherUser.imagePath ??
              'https://robohash.org/placeholder?set=set4&size=200x200'),
        ),
        //Display seller's name
        title: Text(
          otherUser.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        //Display the last message
        subtitle: Text(
          chat.lastMessage ?? 'No messages yet',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(color: grey),
        ),
        trailing: Text(formatTimestamp(chat.lastMessageTime)),
        //Navigate to the chating page between user & seller
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
      ),
    );
  }
}
