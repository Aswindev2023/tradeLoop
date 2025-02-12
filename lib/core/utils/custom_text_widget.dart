import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;

  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.softWrap,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? (kIsWeb ? 16.0 : 14.0),
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? blackColor,
      ),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      softWrap: softWrap,
      overflow: overflow,
    );
  }
}
