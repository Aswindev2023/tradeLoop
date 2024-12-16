import 'package:flutter/material.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';

class AuthUtils {
  static Future<void> handleLogin({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Function(String? emailError, String? passwordError) onValidation,
    required Function() onLoginTap,
    required Function(bool isLoading) setLoadingState,
  }) async {
    String? emailValidationError =
        FormValidators.validateForm(emailController.text, 'Email');
    String? passwordValidationError =
        FormValidators.validateForm(passwordController.text, 'Password');

    // Pass validation errors back to the caller
    onValidation(emailValidationError, passwordValidationError);

    if (emailValidationError == null && passwordValidationError == null) {
      setLoadingState(true); // Set loading state to true
      try {
        await Future.delayed(const Duration(seconds: 1));
        onLoginTap();
      } finally {
        setLoadingState(false); // Set loading state to false
      }
    }
  }
}
