import 'package:flutter/material.dart';

class CustomTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final FontWeight? customFontWeight;
  const CustomTileWidget(
      {super.key, required this.title, this.onTap, this.customFontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 249, 249),
          borderRadius: BorderRadius.circular(7),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: customFontWeight ?? FontWeight.w500,
              fontSize: 20,
            ),
          ),
          onTap: onTap,
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        ),
      ),
    );
  }
}
