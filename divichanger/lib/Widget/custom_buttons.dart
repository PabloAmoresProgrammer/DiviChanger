import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Función que se ejecutará cuando se toque el botón.
  final VoidCallback onButtonPressed;

  // Texto que aparecerá en el botón.
  final String buttonText;

  // Constructor que inicializa los valores requeridos.
  const CustomButton({
    super.key,
    required this.onButtonPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Define la acción que ocurre al tocar el botón.
      onTap: onButtonPressed,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          // Centra el texto dentro del botón.
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),

          // Estilo del boton
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            color: Color(0xff259AC5), // Color de fondo del botón.
          ),

          // Texto que se muestra dentro del botón.
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20, // Tamaño del texto.
              color: Colors.white, // Color del texto.
              fontWeight: FontWeight.bold, // En negrita.
            ),
          ),
        ),
      ),
    );
  }
}
