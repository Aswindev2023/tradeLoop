import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/widgets/input_field_widget.dart';

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
          if (state is AuthSuccess) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Placeholder()));
          } else if (state is AuthFailure) {
            SnackbarUtils.showSnackbar(
              context,
              state.message,
              backgroundColor: Colors.orangeAccent,
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/car (1).PNG",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
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
                          controller: _emailController,
                          hintText: 'Email',
                          //fieldName: 'Email',
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (FormValidators.isValidEmail(
                                    _emailController.text)) {
                                  BlocProvider.of<AuthBlocBloc>(context)
                                      .add(ForgotPasswordEvent(
                                    email: _emailController.text,
                                  ));
                                } else {
                                  SnackbarUtils.showSnackbar(
                                      context, 'Invalid Email Format');
                                }
                              } else {
                                print('sent email button validation');
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
                              "Sent Email",
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
  }
}
