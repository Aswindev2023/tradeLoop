import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Account Restricted',
        backgroundColor: appbarWhiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LogIn()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back, color: blackColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App title section
            Text(
              "Account Suspended",
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: redAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message about ban
            Text(
              "Your account has been suspended due to a violation of our platform policies. "
              "This action ensures a safe and respectful environment for all our users.",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Next steps and contact information
            Text(
              "What Can You Do?",
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "If you believe this suspension was a mistake, please reach out to our support team. "
              "Provide your account details and any additional information to help us review your case.",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: grey800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Contact information section
            ContactInfo(
              icon: Icons.email,
              label: "Email",
              value: "support@tradeloop.com",
              isSmallScreen: isSmallScreen,
            ),

            ContactInfo(
              icon: Icons.location_on,
              label: "Location",
              value: "123 TradeLoop St, Tech City",
              isSmallScreen: isSmallScreen,
            ),
            const SizedBox(height: 24),

            // Social media section
            Text(
              "Stay Updated",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialMediaIcon(
                    icon: FontAwesomeIcons.facebook, color: blueColor),
                SocialMediaIcon(
                    icon: FontAwesomeIcons.xTwitter, color: twitterBlack),
                SocialMediaIcon(
                    icon: FontAwesomeIcons.instagram, color: instaPink),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSmallScreen;

  const ContactInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: isSmallScreen ? 20 : 24, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SocialMediaIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(icon, size: 30, color: color),
    );
  }
}
