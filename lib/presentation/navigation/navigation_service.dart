import 'package:flutter/material.dart';
import 'package:trade_loop/main.dart';
import 'package:trade_loop/presentation/profile/screens/profile_page.dart';

class NavigationService {
  static void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: 'Home',
              )),
    );
  }

  static void navigateToProfilePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  static void navigateToListingPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Placeholder()),
    );
  }

  static void navigateToChatPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Placeholder()),
    );
  }
}
