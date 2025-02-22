import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';

class TermsAndPoliciesPage extends StatelessWidget {
  const TermsAndPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Terms & Policies',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Terms and Conditions section
            CustomTextWidget(
              text: 'Terms and Conditions',
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  '1. Introduction\nWelcome to TradeLoop. These Terms and Conditions govern your use of our app. By using our app, you agree to comply with these terms.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  '2. Acceptable Use\nYou agree not to use the app for any unlawful purposes, or in a way that could harm the app or its users.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(height: 16.0),

            // Privacy Policy section
            CustomTextWidget(
              text: 'Privacy Policy',
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  '1. Data Collection\nWe collect data to provide better services. This includes information you provide, such as your name and email address.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  '2. Data Usage\nWe use your data to improve app functionality, personalize content, and provide customer support.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  '3. Data Sharing\nWe do not share your data with third parties without your consent, except where required by law.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(height: 16.0),

            // Contact Us section
            CustomTextWidget(
              text: 'Contact Us',
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8.0),
            CustomTextWidget(
              text:
                  'If you have any questions about these Terms & Policies, please contact us at support@tradeloop.com.',
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }
}
