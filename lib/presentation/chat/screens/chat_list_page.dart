import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_list_body.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';

class ChatListPage extends StatelessWidget {
  final int selectedIndex = 3;
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print("Current User ID: $currentUserId");

    context.read<ChatBloc>().add(FetchUserChatsEvent(currentUserId));
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Chats',
        backgroundColor: appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatListBody(currentUserId: currentUserId),
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(selectedIndex: selectedIndex),
    );
  }
}
