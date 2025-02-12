import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.text,
    required this.onTap,
    this.backgroundColor = authButtonColor,
    this.textColor = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: whiteColor,
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
