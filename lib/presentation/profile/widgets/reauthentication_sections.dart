import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/authentication/widgets/google_signin_button.dart';
import 'package:trade_loop/presentation/authentication/widgets/input_field_widget.dart';
import 'package:trade_loop/presentation/bloc/account_deletion_bloc/account_deletion_bloc.dart';

class InputFieldsSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool obscurePassword;
  final VoidCallback togglePasswordVisibility;

  const InputFieldsSection({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailError,
    required this.passwordError,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Email input field
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: InputFieldWidget(
            controller: emailController,
            hintText: 'Email',
            errorMessage: emailError,
          ),
        ),
        const SizedBox(height: 15.0),
        // Password input field
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: InputFieldWidget(
            controller: passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            errorMessage: passwordError,
            toggleVisibility: togglePasswordVisibility,
          ),
        ),
      ],
    );
  }
}

// A section that displays the Google Sign-In button.
class GoogleSignInSection extends StatelessWidget {
  const GoogleSignInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GoogleSignInButton(
          onGoogleSignIn: () {
            context.read<AccountDeletionBloc>().add(ReauthenticateWithGoogle());
          },
        ),
      ),
    );
  }
}

// A section that contains a submit button for reauthentication.
class ReauthButtonsSection extends StatelessWidget {
  final VoidCallback onSubmit;

  const ReauthButtonsSection({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
