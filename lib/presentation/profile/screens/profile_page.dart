import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/confirmation_dialog.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/navigation/side_navigation_bar_widget.dart';
import 'package:trade_loop/presentation/profile/screens/settings_page.dart';
import 'package:trade_loop/presentation/profile/screens/view_and_edit_page.dart';
import 'package:trade_loop/presentation/profile/screens/warning_message_page.dart';
import 'package:trade_loop/presentation/profile/screens/wishlisted_product_page.dart';

import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';

class ProfilePage extends StatelessWidget {
  final int selectedIndex = 1;
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    context.read<ProfileBloc>().add(ProfilePageLoaded(userId: userId!));

    return BlocListener<AuthBlocBloc, AuthBlocState>(
      // Handle logout event
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LogIn()));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: CustomTextWidget(text: state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          centerTitle: true,
          title: 'Profile',
          fontColor: whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 30,
          backgroundColor: appbarColor,
        ),
        // Show side navigation bar for web version
        drawer: (kIsWeb)
            ? SideNavigationBarWidget(selectedIndex: selectedIndex)
            : null,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    // Display user's profile image
                    Align(
                      alignment: Alignment.topCenter,
                      child: _buildProfileImage(context),
                    ),
                    const SizedBox(height: 20),
                    // Build profile option tiles
                    ..._buildProfileOptions(context, userId),
                  ],
                ),
              ),
            );
          },
        ),
        // Show bottom navigation bar for mobile version
        bottomNavigationBar: (kIsWeb)
            ? null
            : BottomNavigationBarWidget(
                selectedIndex: selectedIndex,
              ),
      ),
    );
  }

  // List of profile options with navigation
  List<Widget> _buildProfileOptions(BuildContext context, String userId) {
    return [
      CustomTileWidget(
        title: 'View & Edit Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewAndEditPage()),
          );
        },
      ),
      const SizedBox(height: 5),
      CustomTileWidget(
        title: 'My Wishlist',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WishlistedProductsPage(userId: userId),
            ),
          );
        },
      ),
      const SizedBox(height: 5),
      CustomTileWidget(
        title: 'Settings',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(userId: userId),
            ),
          );
        },
      ),
      const SizedBox(height: 5),
      CustomTileWidget(
        title: 'Notices',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarningMessagesPage(userId: userId),
            ),
          );
        },
      ),
      const SizedBox(height: 5),
      CustomTileWidget(
        title: 'Log Out',
        onTap: () {
          _showLogoutDialog(context);
        },
      ),
    ];
  }

  // Builds the profile image widget based on the profile state
  Widget _buildProfileImage(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          String? imageUrl = state.user.imagePath;
          return ClipOval(
            child: Image.network(
              imageUrl ?? 'https://robohash.org/username?set=set5&size=200x200',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          );
        } else if (state is ProfileLoading) {
          // Show a default profile image in case of error
          return const ClipOval(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ClipOval(
            child: Image.network(
              'https://robohash.org/username?set=set5&size=200x200',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  // Shows a logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    final rootContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: 'Logout',
          content: 'Are you sure you want to log out?',
          onConfirm: () {
            rootContext.read<AuthBlocBloc>().add(LogoutEvent());
          },
        );
      },
    );
  }
}
