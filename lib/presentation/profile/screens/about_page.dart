import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App title section
            Text(
              "TradeLoop",
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // App description section
            Text(
              "TradeLoop is your trusted marketplace for second-hand items, "
              "where you can buy and sell products easily and securely. Our "
              "mission is to connect people looking for quality second-hand goods "
              "with those who no longer need them, creating a sustainable loop.",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Vision & Mission Section
            Text(
              "Our Vision & Mission",
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Our vision is to create a sustainable marketplace for everyone. "
              "We aim to reduce waste and promote a circular economy where items find new homes instead of ending up as waste.",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[800],
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
              icon: Icons.phone,
              label: "Phone",
              value: "+91 6478329802",
              isSmallScreen: isSmallScreen,
            ),
            ContactInfo(
              icon: Icons.location_on,
              label: "Location",
              value: "123 TradeLoop St, Tech City",
              isSmallScreen: isSmallScreen,
            ),
            const SizedBox(height: 24),

            // FAQ Section
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const FAQItem(
              question: "How do I list an item for sale?",
              answer:
                  "To list an item, simply go to the 'Add Product' section, upload images, fill in the details, and publish. Your item will be available for others to see.",
            ),
            const FAQItem(
              question: "Is there a fee for using TradeLoop?",
              answer:
                  "No, listing items on TradeLoop is completely free. You only pay if you choose to use premium features in the future.",
            ),
            const FAQItem(
              question: "How do I contact the seller?",
              answer:
                  "Each listing has a 'Contact Seller' option. You can message the seller directly to negotiate and finalize the deal.",
            ),
            // Social media icons section
            Text(
              "Follow Us",
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
                    icon: FontAwesomeIcons.facebook, color: Colors.blue),
                SocialMediaIcon(
                    icon: FontAwesomeIcons.xTwitter,
                    color: Color.fromARGB(255, 13, 13, 13)),
                SocialMediaIcon(
                    icon: FontAwesomeIcons.instagram, color: Colors.pink),
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

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.question,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.answer,
              style: const TextStyle(color: Color.fromARGB(255, 93, 93, 93)),
            ),
          ),
        const Divider(),
      ],
    );
  }
}
