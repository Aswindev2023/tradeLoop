import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/widgets/signup_widget.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pop(context, 'Account Created');
          } else if (state is AuthFailure) {
            SnackbarUtils.showSnackbar(context, state.message,
                backgroundColor: Colors.orangeAccent);
          }
        },
        child: SingleChildScrollView(
          child: SignupWidget(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            onSignUpTap: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<AuthBlocBloc>(context).add(SignUpButtonPressed(
                  email: _emailController.text,
                  password: _passwordController.text,
                  name: _nameController.text,
                ));
              }
            },
            onLogInTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
