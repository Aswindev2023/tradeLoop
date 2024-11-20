import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';

class AuthStateHandler extends StatefulWidget {
  final Widget homePage;
  final Widget loginPage;

  const AuthStateHandler({
    required this.homePage,
    required this.loginPage,
    super.key,
  });

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  @override
  void initState() {
    super.initState();

    context.read<AuthBlocBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          return widget.homePage;
        } else {
          return widget.loginPage;
        }
      },
    );
  }
}
