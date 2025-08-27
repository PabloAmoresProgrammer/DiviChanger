import 'package:flutter/material.dart';

// Muestra un SnackBar con el texto proporcionado en la pantalla.
void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
