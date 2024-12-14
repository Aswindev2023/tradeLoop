import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatPageDataLoaded) {
          return Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  state.sellerImage ??
                      'https://robohash.org/placeholder?set=set4&size=200x200',
                ),
              ),
              const SizedBox(width: 15),
              CustomTextWidget(
                text: state.sellerName,
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ],
          );
        } else if (state is ChatError) {
          return const Text("Error loading seller info");
        }
        return const Text("Loading seller info...");
      },
    );
  }
}
