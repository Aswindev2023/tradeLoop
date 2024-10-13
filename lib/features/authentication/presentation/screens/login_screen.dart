import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/main.dart';
import 'package:trade_loop/features/authentication/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/features/authentication/presentation/screens/forgot_password.dart';
import 'package:trade_loop/features/authentication/presentation/screens/signup_screen.dart';
import 'package:trade_loop/features/authentication/presentation/widgets/login_widget.dart';

class LogIn extends StatelessWidget {
  final String? successMessage;

  LogIn({super.key, this.successMessage});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtils.showSnackbar(context, successMessage!);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'HOME')),
              );
            });
          } else if (state is AuthFailure) {
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: Colors.orangeAccent,
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
                if (FormValidators.isValidEmail(_emailController.text)) {
                  context.read<AuthBlocBloc>().add(LoginButtonPressed(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ));
                } else {
                  SnackbarUtils.showSnackbar(context, 'Invalid Email Format');
                }
              }
            },
            onForgotPasswordTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()))
                  .then((result) {
                if (result != null) {
                  SnackbarUtils.showSnackbar(context, result);
                }
              });
            },
            onGoogleSignIn: () {
              BlocProvider.of<AuthBlocBloc>(context)
                  .add(GoogleSignInButtonPressed());
            },
            onSignUpTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Signup()));
            },
          ),
        ),
      ),
    );
  }
}
