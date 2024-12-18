import 'package:flutter/material.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';
import 'package:trade_loop/presentation/report/screen/report_detail_page.dart';

class ReportTypePage extends StatelessWidget {
  final String sellerId;
  final String currentUserId;

  const ReportTypePage({
    super.key,
    required this.sellerId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> issueTypes = [
      'Fraud or Scams',
      'Inappropriate Content',
      'Harassment or Abuse',
      'Fake Profile',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Seller'),
      ),
      body: ListView.builder(
        itemCount: issueTypes.length,
        itemBuilder: (context, index) {
          return CustomTileWidget(
            title: issueTypes[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailPage(
                      sellerId: sellerId,
                      currentUserId: currentUserId,
                      issueType: issueTypes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
