import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/logout_confirmation_dialog.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/profile/screens/view_and_edit_page.dart';

import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';

class ProfilePage extends StatelessWidget {
  final int selectedIndex = 1;
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LogIn()));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
              child: ClipOval(
                child: Image.network(
                  'https://imgs.search.brave.com/lXARFlhuh5b05jTaVbYAR4Hkm6ej0pvCgysnSklYjr8/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTMz/ODI4OTgyNC9waG90/by9jbG9zZS11cC1p/bWFnZS1vZi1pbmRp/YW4tbWFuLXdpdGgt/YnV6ei1jdXQtaGFp/cnN0eWxlLXRvLWRp/c2d1aXNlLXJlY2Vk/aW5nLWhhaXJsaW5l/LXdlYXJpbmctdC53/ZWJwP2E9MSZiPTEm/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9X1pD/WlY5T1BSVmJvYUQy/TnhMVWI3RjFYZEtk/dnlOUVNZVzNleXFV/eHpVUT0',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
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
              onTap: () {},
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

  void _showLogoutDialog(BuildContext context) {
    final rootContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return LogoutConfirmationDialog(
          onConfirm: () {
            rootContext.read<AuthBlocBloc>().add(LogoutEvent());
          },
        );
      },
    );
  }
}
