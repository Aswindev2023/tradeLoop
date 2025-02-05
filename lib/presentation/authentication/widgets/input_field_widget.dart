import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/input_field_utils.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? errorMessage;
  final bool obscureText;
  final VoidCallback? toggleVisibility;

  const InputFieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.errorMessage,
    this.obscureText = false,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final isWeb = kIsWeb;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isWeb ? 400 : double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: isWeb ? 20.0 : 30.0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFedf0f8),
            borderRadius: BorderRadius.circular(isWeb ? 10 : 20),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(fontSize: isWeb ? 16.0 : 18.0),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFb2b7bf),
                fontSize: isWeb ? 16.0 : 18.0,
              ),
              suffixIcon: getPasswordVisibilityIcon(
                obscureText: obscureText,
                toggleVisibility: toggleVisibility,
              ),
            ),
          ),
        ),
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 20.0 : 25.0,
              vertical: 5.0,
            ),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: red,
                fontSize: isWeb ? 12.0 : 14.0,
              ),
            ),
          ),
      ],
    );
  }
}
