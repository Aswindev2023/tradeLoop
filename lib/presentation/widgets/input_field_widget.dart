import 'package:flutter/material.dart';
//import 'package:trade_loop/core/utils/form_validation_message.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  //final String fieldName;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
          decoration: BoxDecoration(
            color: const Color(0xFFedf0f8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
            ),
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
