import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/profile/screens/about_page.dart';
import 'package:trade_loop/presentation/profile/screens/terms_and_policies_page.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';
import 'package:trade_loop/presentation/profile/screens/reauthentication_page.dart';

class SettingsPage extends StatelessWidget {
  final String userId;

  const SettingsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Settings',
        fontWeight: FontWeight.bold,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 15),
            //Navigate to About Us page
            CustomTileWidget(
              title: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            //Navigate to Terms & Policies page
            CustomTileWidget(
              title: 'Terms & Policies',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndPoliciesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            //Navigate to Delete Account Page
            CustomTileWidget(
              title: 'Delete Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReauthenticationPage(
                      userId: userId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
