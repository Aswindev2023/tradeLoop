import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/warning_bloc/warning_bloc.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
}

class WarningMessagesPage extends StatelessWidget {
  final String userId;

  const WarningMessagesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Your Warnings',
        fontWeight: FontWeight.w400,
        fontColor: blackColor,
        backgroundColor: whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            )),
      ),
      body: BlocProvider(
        create: (context) =>
            WarningBloc()..add(FetchWarningsEvent(userId: userId)),
        child: BlocBuilder<WarningBloc, WarningState>(
          builder: (context, state) {
            if (state is WarningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WarningLoaded) {
              /// Display the list of warnings if data is successfully loaded
              final warnings = state.warnings;
              if (warnings.isEmpty) {
                return const Center(child: Text('No warnings found.'));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: warnings.length,
                  itemBuilder: (context, index) {
                    final warning = warnings[index];
                    return ListTile(
                      /// Display the warning title in bold
                      title: CustomTextWidget(
                          text: warning.title, fontWeight: FontWeight.bold),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Display the warning message and timestamp
                          CustomTextWidget(text: warning.message),
                          const SizedBox(height: 8),
                          CustomTextWidget(
                              text: formatDate(warning.timestamp),
                              color: grey,
                              fontSize: 12),
                        ],
                      ),
                      isThreeLine: true,
                    );
                  },

                  /// Divider between warning messages for better UI clarity
                  separatorBuilder: (context, index) => Divider(
                    color: grey[300],
                    thickness: 1,
                    height: 16,
                  ),
                ),
              );
            } else if (state is WarningError) {
              return Center(
                  child: CustomTextWidget(text: 'Error: ${state.message}'));
            } else {
              return const Center(
                  child: CustomTextWidget(text: 'No warnings found.'));
            }
          },
        ),
      ),
    );
  }
}
