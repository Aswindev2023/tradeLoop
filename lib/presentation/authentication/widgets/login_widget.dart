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
    if (!mounted) return;
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
      try {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        widget.onLoginTap();
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
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
    double screenWidth = MediaQuery.of(context).size.width;

    double labelFontSize = screenWidth < 400 ? 16.0 : 18.0;
    double paddingHorizontal = screenWidth * 0.05;

    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          child: Image.asset(
            "images/car (1).PNG",
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: labelFontSize,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: labelFontSize,
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
          child: Text(
            "Forgot Password?",
            style: TextStyle(
                color: const Color(0xFF8c8e98),
                fontSize: screenWidth < 400 ? 16.0 : 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          "or",
          style: TextStyle(
              color: const Color(0xFF273671),
              fontSize: screenWidth < 400 ? 16.0 : 22.0,
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
            Text(
              "Don't have an account?",
              style: TextStyle(
                  color: const Color(0xFF8c8e98),
                  fontSize: screenWidth < 400 ? 16.0 : 18.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 5.0),
            GestureDetector(
              onTap: widget.onSignUpTap,
              child: Text(
                "SignUp",
                style: TextStyle(
                    color: const Color(0xFF273671),
                    fontSize: screenWidth < 400 ? 16.0 : 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
