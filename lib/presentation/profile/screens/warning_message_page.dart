import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(title: const Text('Your Warnings')),
      body: BlocProvider(
        create: (context) =>
            WarningBloc()..add(FetchWarningsEvent(userId: userId)),
        child: BlocBuilder<WarningBloc, WarningState>(
          builder: (context, state) {
            if (state is WarningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WarningLoaded) {
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
                      title: Text(warning.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(warning.message),
                          const SizedBox(height: 8),
                          Text(
                            formatDate(warning.timestamp),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    height: 16,
                  ),
                ),
              );
            } else if (state is WarningError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No warnings found.'));
            }
          },
        ),
      ),
    );
  }
}
