import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';

class AuthStateHandler extends StatefulWidget {
  final Widget homePage;
  final Widget loginPage;
  final Widget bannedPage;

  const AuthStateHandler({
    required this.homePage,
    required this.loginPage,
    required this.bannedPage,
    super.key,
  });

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    print('auth state handler initialized');

    // Initialize the listener and store the subscription
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('auth state handler called listener for auth state changes');
      if (user != null && mounted) {
        context.read<AuthBlocBloc>().add(CheckAuthStatus());
      }
    });

    // Trigger initial check for the authentication status
    context.read<AuthBlocBloc>().add(CheckAuthStatus());
  }

  @override
  void dispose() {
    // Cancel the listener to avoid memory leaks
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, state) {
        print('state in auth state handler is $state');
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return widget.homePage;
        } else if (state is UserBanned) {
          return widget.bannedPage;
        } else if (state is AuthLoggedOut) {
          return widget.loginPage;
        } else {
          return const Scaffold(
            body: Center(child: Text('Unexpected State')),
          );
        }
      },
    );
  }
}
