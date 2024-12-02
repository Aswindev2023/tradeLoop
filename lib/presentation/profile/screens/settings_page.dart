import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/profile/screens/about_page.dart';
import 'package:trade_loop/presentation/profile/screens/terms_and_policies_page.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Settings',
        fontWeight: FontWeight.bold,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          CustomTileWidget(
            title: 'About Us',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ));
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTileWidget(
            title: 'Terms & Policies',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndPoliciesPage(),
                  ));
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTileWidget(
            title: 'Delete Account',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
