import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor = const Color.fromARGB(255, 55, 227, 21),
    this.fontSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              vertical: 13.0,
              horizontal: 30.0,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: kIsWeb
                  ? [
                      const BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? fontSize + 2 : fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
