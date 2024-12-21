import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/authentication/widgets/input_field_widget.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: BlocListener<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LogIn()));
          } else if (state is AuthFailure) {
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: snackbarColor,
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 600;
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: isWideScreen ? 600 : double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset(
                          "images/AnyConv.com__screenimage.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isWideScreen ? 32.0 : 16.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
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
                                const SizedBox(height: 8.0),
                                InputFieldWidget(
                                  controller: _emailController,
                                  hintText: 'Email',
                                ),
                                const SizedBox(height: 20.0),
                                SizedBox(
                                  width: isWideScreen
                                      ? constraints.maxWidth * 0.5
                                      : double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (FormValidators.isValidEmail(
                                          _emailController.text)) {
                                        context
                                            .read<AuthBlocBloc>()
                                            .add(ForgotPasswordEvent(
                                              email: _emailController.text,
                                            ));
                                      } else {
                                        SnackbarUtils.showSnackbar(
                                            context, 'Invalid Email Format');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13.0, horizontal: 30.0),
                                      backgroundColor: authButtonColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Send Email",
                                      style: TextStyle(
                                          color: authButtonTextColor,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
