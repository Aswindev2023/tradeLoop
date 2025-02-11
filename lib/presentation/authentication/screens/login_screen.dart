import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
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
  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for email and password input fields
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.01;

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          // Navigate to HomePage on successful login
          if (state is AuthSuccess) {
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            });
          } else if (state is AuthFailure) {
            // Show error message
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: snackbarColor,
            );
          } else if (state is UserBanned) {
            // Handle banned users
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: snackbarColor,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    // Handle login button press
                    onLoginTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (FormValidators.isValidEmail(
                            _emailController.text)) {
                          context.read<AuthBlocBloc>().add(LoginButtonPressed(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ));
                        } else {
                          SnackbarUtils.showSnackbar(
                            context,
                            'Invalid Email Format',
                          );
                        }
                      }
                    },
                    // Navigate to Forgot Password screen
                    onForgotPasswordTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      ).then((result) {
                        if (result != null) {
                          SnackbarUtils.showSnackbar(context, result);
                        }
                      });
                    },
                    // Handle Google sign-in
                    onGoogleSignIn: () {
                      BlocProvider.of<AuthBlocBloc>(context)
                          .add(GoogleSignInButtonPressed());
                    },
                    // Navigate to Sign Up screen
                    onSignUpTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
