import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
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
      appBar: CustomAppbar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            )),
        title: 'Report Seller',
        fontSize: 23,
        fontColor: blackColor,
        backgroundColor: whiteColor,
      ),
      //Display Report Types
      body: ListView.builder(
        itemCount: issueTypes.length,
        itemBuilder: (context, index) {
          return CustomTileWidget(
            title: issueTypes[index],
            onTap: () {
              //Navigate to Report Details Page
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
