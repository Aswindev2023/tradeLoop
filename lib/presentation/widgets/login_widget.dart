import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/validation_bloc/validation_bloc.dart';
import 'package:trade_loop/presentation/widgets/input_field_widget.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginTap;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSignUpTap;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
    required this.onForgotPasswordTap,
    required this.onGoogleSignIn,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValidationBloc, ValidationState>(
      listener: (context, state) {
        if (state is ValidationError) {
          // Handle the error state (display error message)
          SnackbarUtils.showSnackbar(context, state.message);
        }
      },
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/car (1).PNG",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InputFieldWidget(
                    controller: emailController,
                    hintText: 'Email',
                    //fieldName: 'Email',
                    validator: (value) {
                      return FormValidators.validateForm(value, 'Email');
                    },
                  ),
                  const SizedBox(height: 30.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InputFieldWidget(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    //fieldName: 'Password',
                    validator: (value) {
                      return FormValidators.validateForm(value, 'Password');
                    },
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        onLoginTap();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: authButtonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: authButtonTextColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: onForgotPasswordTap,
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                  color: Color(0xFF8c8e98),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 40.0),
          const Text(
            "or LogIn with",
            style: TextStyle(
                color: Color(0xFF273671),
                fontSize: 22.0,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onGoogleSignIn,
                child: Image.asset(
                  "images/car (1).PNG",
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                    color: Color(0xFF8c8e98),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 5.0),
              GestureDetector(
                onTap: onSignUpTap,
                child: const Text(
                  "SignUp",
                  style: TextStyle(
                      color: Color(0xFF273671),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
