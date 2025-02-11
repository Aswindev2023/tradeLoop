import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/input_field_utils.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditable;
  final bool isObscured;
  final VoidCallback? toggleVisibility;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditable,
    this.isObscured = false,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditable,
        obscureText: isObscured,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: controller.text.isEmpty ? grey[300] : Colors.transparent,
          border: const OutlineInputBorder(),
          suffixIcon: getPasswordVisibilityIcon(
            obscureText: isObscured,
            toggleVisibility: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
