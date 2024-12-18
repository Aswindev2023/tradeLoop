import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/authentication/screens/forgot_password.dart';
import 'package:trade_loop/presentation/authentication/screens/signup_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/login_widget.dart';
import 'package:trade_loop/presentation/home/screens/home_page.dart';

class LogIn extends StatefulWidget {
  final String? successMessage;

  const LogIn({super.key, this.successMessage});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtils.showSnackbar(context, widget.successMessage!);
      });
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.001;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            });
          } else if (state is AuthFailure) {
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: const Color.fromARGB(255, 169, 35, 35),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
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
                      SnackbarUtils.showSnackbar(
                          context, 'Invalid Email Format');
                    }
                  }
                },
                onForgotPasswordTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()))
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
