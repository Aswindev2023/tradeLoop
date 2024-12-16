import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/bloc/account_deletion_bloc/account_deletion_bloc.dart';
import 'package:trade_loop/presentation/authentication/widgets/google_signin_button.dart';
import 'package:trade_loop/presentation/authentication/widgets/input_field_widget.dart';

class ReauthenticationPage extends StatefulWidget {
  final String userId;

  const ReauthenticationPage({super.key, required this.userId});

  @override
  State<ReauthenticationPage> createState() => _ReauthenticationPageState();
}

class _ReauthenticationPageState extends State<ReauthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _validateAndSubmit() {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password is required' : null;
    });

    if (FormValidators.isValidEmail(_emailController.text)) {
      if (_emailError == null && _passwordError == null) {
        context.read<AccountDeletionBloc>().add(
              ReauthenticateWithEmailPassword(
                _emailController.text.trim(),
                _passwordController.text.trim(),
              ),
            );
      }
    } else {
      SnackbarUtils.showSnackbar(context, 'Enter a valid email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Reauthentication')),
      body: BlocListener<AccountDeletionBloc, AccountDeletionState>(
        listener: (context, state) {
          if (state is ReauthenticationFailure) {
            SnackbarUtils.showSnackbar(context, state.errorMessage);
          } else if (state is ReauthenticationSuccess) {
            _showDeletionDialog(context);
          } else if (state is DeleteAccountSuccess) {
            SnackbarUtils.showSnackbar(context, 'Account Deleted');
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LogIn()),
                (route) => false,
              );
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'To proceed with account deletion, please reauthenticate by providing your email and password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20.0),
                InputFieldWidget(
                  controller: _emailController,
                  hintText: 'Email',
                  errorMessage: _emailError,
                ),
                const SizedBox(height: 15.0),
                InputFieldWidget(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  errorMessage: _passwordError,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 20.0),
                GoogleSignInButton(
                  onGoogleSignIn: () {
                    context
                        .read<AccountDeletionBloc>()
                        .add(ReauthenticateWithGoogle());
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: width * 0.8,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AccountDeletionBloc>().add(
                    DeleteAccountRequested(widget.userId),
                  );
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
