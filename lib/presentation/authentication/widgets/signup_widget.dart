import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/presentation/authentication/widgets/input_field_widget.dart';
import 'package:trade_loop/presentation/authentication/widgets/loding_button.dart';

class SignupWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final VoidCallback onSignUpTap;
  final VoidCallback onLogInTap;

  const SignupWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.onSignUpTap,
    required this.onLogInTap,
  });

  @override
  SignupWidgetState createState() => SignupWidgetState();
}

class SignupWidgetState extends State<SignupWidget> {
  String? emailError;
  String? passwordError;
  String? nameError;
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleSignin() async {
    String? emailValidationError =
        FormValidators.validateForm(widget.emailController.text, 'Email');
    String? passwordValidationError =
        FormValidators.validateForm(widget.passwordController.text, 'Password');
    String? nameValidationError =
        FormValidators.validateForm(widget.nameController.text, 'Name');

    setState(() {
      emailError = emailValidationError;
      passwordError = passwordValidationError;
      nameError = nameValidationError;
    });

    if (emailError == null && passwordError == null && nameError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 1));
        widget.onSignUpTap();
      } finally {
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
    widget.nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SignupHeader(),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                InputSection(
                  label: "Name",
                  controller: widget.nameController,
                  errorMessage: nameError,
                ),
                const SizedBox(height: 30.0),
                InputSection(
                  label: "Email",
                  controller: widget.emailController,
                  errorMessage: emailError,
                ),
                const SizedBox(height: 30.0),
                InputSection(
                  label: "Password",
                  controller: widget.passwordController,
                  obscureText: _obscurePassword,
                  errorMessage: passwordError,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 30.0),
                LoadingButton(
                  isLoading: _isLoading,
                  text: 'Sign Up',
                  onTap: _handleSignin,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 40.0),
        _SignupFooter(onLogInTap: widget.onLogInTap),
      ],
    );
  }
}

class _SignupHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        "images/AnyConv.com__screenimage.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}

class InputSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorMessage;
  final bool? obscureText;
  final VoidCallback? toggleVisibility;

  const InputSection({
    super.key,
    required this.label,
    required this.controller,
    this.errorMessage,
    this.obscureText,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: CustomTextWidget(
            text: label,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        InputFieldWidget(
          controller: controller,
          hintText: label,
          errorMessage: errorMessage,
          obscureText: obscureText ?? false,
          toggleVisibility: toggleVisibility,
        ),
      ],
    );
  }
}

class _SignupFooter extends StatelessWidget {
  final VoidCallback onLogInTap;

  const _SignupFooter({required this.onLogInTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomTextWidget(
          text: "Already have an account?",
          color: greyButtonCol,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: onLogInTap,
          child: const CustomTextWidget(
            text: "LogIn",
            color: darkBlueCo,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
