import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/presentation/navigation/navigation_service.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.comment),
          label: 'Chats',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: whiteColor,
      selectedItemColor: blueColor,
      unselectedItemColor: blackColor,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        NavigationService.navigateToHomePage(context);
        break;
      case 1:
        NavigationService.navigateToProfilePage(context);
        break;
      case 2:
        NavigationService.navigateToListingPage(context);
        break;
      case 3:
        NavigationService.navigateToChatPage(context);
        break;
    }
  }
}
