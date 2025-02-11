import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/chat/widgets/chat_list_body.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/navigation/side_navigation_bar_widget.dart';

class ChatListPage extends StatelessWidget {
  final int selectedIndex = 3;
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    //context.read<ChatBloc>().add(FetchUserChatsEvent(currentUserId));
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Chats',
        backgroundColor: appbarColor,
      ),
      //Show navigation drawer for web
      drawer: (kIsWeb)
          ? SideNavigationBarWidget(selectedIndex: selectedIndex)
          : null,
      //Display list of chats
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatListBody(currentUserId: currentUserId),
      ),
      //Show navigation bar for android
      bottomNavigationBar: (kIsWeb)
          ? null
          : BottomNavigationBarWidget(
              selectedIndex: selectedIndex,
            ),
    );
  }
}
