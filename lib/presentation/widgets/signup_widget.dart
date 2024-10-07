import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/presentation/widgets/input_field_widget.dart';

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
                  // fieldName: 'Name',
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
                  // fieldName: 'Email',
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
                  // fieldName: 'Password',
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
                      nameError = FormValidators.validateForm(
                          widget.nameController.text, 'Name');
                    });

                    if (emailError == null &&
                        passwordError == null &&
                        nameError == null) {
                      widget.onSignUpTap;
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
                        "Sign Up",
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
