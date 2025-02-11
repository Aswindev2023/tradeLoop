import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';

class EditButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const EditButton({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: editButtonCol,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          isEditing ? 'Save Changes' : 'Edit',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
