import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
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
      leading: leading,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor:
          foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      centerTitle: centerTitle ?? true,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.bold,
          color: fontColor ?? Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
