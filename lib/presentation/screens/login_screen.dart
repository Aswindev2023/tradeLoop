import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/widgets/login_widget.dart';
import 'package:trade_loop/services/auth_services.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => AuthBlocBloc(authServices),
        child: BlocListener<AuthBlocBloc, AuthBlocState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Placeholder()));
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.orangeAccent,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: LoginForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              onLoginTap: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<AuthBlocBloc>(context).add(LoginButtonPressed(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ));
                }
              },
              onForgotPasswordTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Placeholder()));
              },
              onGoogleSignIn: () {
                // Google Sign-In logic here
              },
              onAppleSignIn: () {
                // Apple Sign-In logic here
              },
              onSignUpTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Placeholder()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
