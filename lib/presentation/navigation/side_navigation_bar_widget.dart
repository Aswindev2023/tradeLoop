import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trade_loop/presentation/navigation/navigation_service.dart';

class SideNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;

  const SideNavigationBarWidget({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerItem(
            context,
            icon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.user,
            label: 'Profile',
            index: 1,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.post_add,
            label: 'Sell',
            index: 2,
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.comment,
            label: 'Chats',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selectedIndex == index,
      onTap: () {
        _onItemTapped(context, index);
      },
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
