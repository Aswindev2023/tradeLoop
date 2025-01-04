import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/confirmation_dialog.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
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
      listener: (context, state) {
        print('state is profile page is:$state');
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LogIn()));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          centerTitle: true,
          title: 'Profile',
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
          backgroundColor: appbarColor,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildProfileImage(context),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTileWidget(
              title: 'View & Edit Profile',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewAndEditPage(),
                    ));
              },
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTileWidget(
              title: 'My Wishlist',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishlistedProductsPage(
                        userId: userId,
                      ),
                    ));
              },
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTileWidget(
              title: 'Settings',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        userId: userId,
                      ),
                    ));
              },
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTileWidget(
              title: 'Notices',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WarningMessagesPage(userId: userId)));
              },
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTileWidget(
              title: 'Log Out',
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        bottomNavigationBar:
            BottomNavigationBarWidget(selectedIndex: selectedIndex),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
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
    });
  }

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
