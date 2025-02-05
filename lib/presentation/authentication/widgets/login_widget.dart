import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
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

    setState(() {
      emailError =
          FormValidators.validateForm(widget.emailController.text, 'Email');
      passwordError = FormValidators.validateForm(
          widget.passwordController.text, 'Password');
    });

    if (emailError == null && passwordError == null) {
      setState(() => _isLoading = true);

      try {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        widget.onLoginTap();
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        _buildHeaderImage(screenWidth),
        const SizedBox(height: 30.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: _buildLoginForm(screenWidth),
        ),
        const SizedBox(height: 20.0),
        _buildForgotPasswordButton(screenWidth),
        const SizedBox(height: 20.0),
        CustomTextWidget(
          text: "or",
          fontSize: screenWidth < 400 ? 16.0 : 22.0,
          fontWeight: FontWeight.w500,
          color: darkBlueCo,
        ),
        const SizedBox(height: 30.0),
        _buildGoogleSignInButton(),
        const SizedBox(height: 30.0),
        _buildSignUpSection(screenWidth),
      ],
    );
  }

  Widget _buildHeaderImage(double screenWidth) {
    return SizedBox(
      width: screenWidth,
      child: Image.asset(
        "images/AnyConv.com__screenimage.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildLoginForm(double screenWidth) {
    final labelFontSize = screenWidth < 400 ? 16.0 : 18.0;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Email Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: CustomTextWidget(
                  text: "Email",
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              InputFieldWidget(
                controller: widget.emailController,
                hintText: 'Email',
                errorMessage: emailError,
              ),
            ],
          ),
          const SizedBox(height: 30.0),

          // Password Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: CustomTextWidget(
                  text: "Password",
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.bold,
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
            ],
          ),
          const SizedBox(height: 30.0),

          // Login Button
          LoadingButton(
            isLoading: _isLoading,
            text: 'Log In',
            onTap: _handleLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordButton(double screenWidth) {
    return GestureDetector(
      onTap: widget.onForgotPasswordTap,
      child: CustomTextWidget(
          text: "Forgot Password?",
          fontSize: screenWidth < 400 ? 16.0 : 18.0,
          fontWeight: FontWeight.w500,
          color: greyButtonCol),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GoogleSignInButton(onGoogleSignIn: widget.onGoogleSignIn),
      ],
    );
  }

  Widget _buildSignUpSection(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextWidget(
          text: "Don't have an account?",
          fontSize: screenWidth < 400 ? 16.0 : 18.0,
          fontWeight: FontWeight.w500,
          color: greyButtonCol,
        ),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: widget.onSignUpTap,
          child: CustomTextWidget(
            text: "SignUp",
            fontSize: screenWidth < 400 ? 16.0 : 20.0,
            fontWeight: FontWeight.w500,
            color: darkBlueCo,
          ),
        ),
      ],
    );
  }
}
