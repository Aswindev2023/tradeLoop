import 'package:flutter/material.dart';
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

      await Future.delayed(const Duration(seconds: 1));
      widget.onSignUpTap();
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
                      "Name",
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
                  controller: widget.nameController,
                  hintText: 'Name',
                  errorMessage: nameError,
                ),
                const SizedBox(height: 30.0),
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
                    isLoading: _isLoading,
                    text: 'Sign Up',
                    onTap: _handleSignin)
              ],
            ),
          ),
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                  color: Color(0xFF8c8e98),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 5.0),
            GestureDetector(
              onTap: widget.onLogInTap,
              child: const Text(
                "LogIn",
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
