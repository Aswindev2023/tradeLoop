import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/confirmation_dialog.dart';
import 'package:trade_loop/presentation/bloc/account_deletion_bloc/account_delete_bloc.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/profile/screens/about_page.dart';
import 'package:trade_loop/presentation/profile/screens/view_and_edit_page.dart';

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
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LogIn()));
        } else if (state is AuthFailure) {
          SnackbarUtils.showSnackbar(context, state.message);
        }
      },
      child: BlocListener<AccountDeleteBloc, AccountDeleteState>(
        listener: (context, state) {
          if (state is AccountDeletionSuccess) {
            context.read<AuthBlocBloc>().add(LogoutEvent());
          } else if (state is AccountDeletionFailure) {
            SnackbarUtils.showSnackbar(context, state.error);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 17, 28, 233),
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                onTap: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTileWidget(
                title: 'About',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ));
                },
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTileWidget(
                title: 'Log Out',
                onTap: () {
                  _showLogOutDialog(context);
                },
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTileWidget(
                title: 'Delete Account',
                onTap: () {
                  _showDeletionDialog(context, userId);
                },
              ),
            ],
          ),
          bottomNavigationBar:
              BottomNavigationBarWidget(selectedIndex: selectedIndex),
        ),
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
        return const ClipOval(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      }
    });
  }

  void _showLogOutDialog(BuildContext context) {
    final rootContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          onConfirm: () {
            rootContext.read<AuthBlocBloc>().add(LogoutEvent());
          },
          text: 'Logout',
          content: 'Are you sure you want to log out?',
        );
      },
    );
  }

  void _showDeletionDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          onConfirm: () {
            final deleteBloc = context.read<AccountDeleteBloc>();
            deleteBloc.add(DeleteUserProductsEvent(userId));
            deleteBloc.add(DeleteUserAccountEvent(userId));
          },
          text: 'Delete Account',
          content: 'Are you sure you want to permanently delete your account?',
        );
      },
    );
  }
}
