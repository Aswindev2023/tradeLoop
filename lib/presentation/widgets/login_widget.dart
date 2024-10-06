import 'package:flutter/material.dart';
import 'package:trade_loop/presentation/widgets/input_field_widget.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginTap;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final VoidCallback onSignUpTap;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
    required this.onForgotPasswordTap,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.onSignUpTap,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? emailError;
  String? passwordError;

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
                  fieldName: 'Email',
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
                  fieldName: 'Password',
                  obscureText: true,
                  errorMessage: passwordError,
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      emailError = FormValidators.validateForm(
                          widget.emailController.text, 'Email');
                      passwordError = FormValidators.validateForm(
                          widget.passwordController.text, 'Password');
                    });

                    if (emailError == null && passwordError == null) {
                      widget.onLoginTap();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 13.0, horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 14, 58, 237),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
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
          onTap: widget.onForgotPasswordTap,
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
              onTap: widget.onGoogleSignIn,
              child: Image.asset(
                "images/car (1).PNG",
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 30.0),
            GestureDetector(
              onTap: widget.onAppleSignIn,
              child: Image.asset(
                "images/car (1).PNG",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
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
