import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
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
    final double padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          //After Success Navigate to login page
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
              backgroundColor: orangeAcc,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  //Sign up Widget Session
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
                    //Navigate to login page
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
