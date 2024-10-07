import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String fieldName;
  final String? errorMessage;
  final bool obscureText;

  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fieldName,
    this.errorMessage,
    this.obscureText = false,
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
          ),
        ),
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ),
      ],
    );
  }
}
