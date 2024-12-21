import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/signup_widget.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding =
        screenWidth * 0.05; // Adjust padding for responsiveness

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogIn(
                      successMessage: 'Account created successfully!'),
                ),
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
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 400), // Centralized for web
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SignupWidget(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    nameController: _nameController,
                    onSignUpTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (FormValidators.isValidEmail(
                                _emailController.text) &&
                            FormValidators.isValidName(_nameController.text) &&
                            FormValidators.isValidPassword(
                                _passwordController.text)) {
                          context.read<AuthBlocBloc>().add(SignUpButtonPressed(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                              ));
                        } else {
                          SnackbarUtils.showSnackbar(
                            context,
                            'Invalid Email/Name/Password Format',
                          );
                        }
                      }
                    },
                    onLogInTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const LogIn(),
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
