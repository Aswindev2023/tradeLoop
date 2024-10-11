import 'package:flutter/material.dart';

IconButton? getPasswordVisibilityIcon({
  required bool obscureText,
  required VoidCallback? toggleVisibility,
}) {
  return toggleVisibility != null
      ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleVisibility,
        )
      : null;
}
