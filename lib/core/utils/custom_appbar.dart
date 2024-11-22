import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final Icon? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool? centerTitle;
  final FontWeight? fontWeight;
  final Color? fontColor;

  const CustomAppbar({
    super.key,
    required this.title,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle,
    this.fontWeight,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
