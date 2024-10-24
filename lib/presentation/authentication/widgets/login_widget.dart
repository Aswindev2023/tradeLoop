import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';

import 'package:trade_loop/presentation/authentication/widgets/google_signin_button.dart';
import 'package:trade_loop/presentation/authentication/widgets/input_field_widget.dart';
import 'package:trade_loop/presentation/authentication/widgets/loding_button.dart';

class LoginForm extends StatefulWidget {
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
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String? emailError;
  String? passwordError;
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    String? emailValidationError =
        FormValidators.validateForm(widget.emailController.text, 'Email');
    String? passwordValidationError =
        FormValidators.validateForm(widget.passwordController.text, 'Password');

    setState(() {
      emailError = emailValidationError;
      passwordError = passwordValidationError;
    });

    if (emailError == null && passwordError == null) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      widget.onLoginTap();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            key: widget.formKey,
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
                  controller: widget.emailController,
                  hintText: 'Email',
                  errorMessage: emailError,
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
                  controller: widget.passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  errorMessage: passwordError,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 30.0),
                LoadingButton(
                    isLoading: _isLoading, text: 'Log In', onTap: _handleLogin),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        GestureDetector(
          onTap: widget.onForgotPasswordTap,
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
                color: Color(0xFF8c8e98),
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          "or",
          style: TextStyle(
              color: Color(0xFF273671),
              fontSize: 22.0,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleSignInButton(onGoogleSignIn: widget.onGoogleSignIn),
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
              onTap: widget.onSignUpTap,
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
    );
  }
}
