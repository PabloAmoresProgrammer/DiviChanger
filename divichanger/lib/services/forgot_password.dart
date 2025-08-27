import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:divichanger/screens/screens.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controlador para el campo de texto donde el usuario ingresa su correo electrónico.
  TextEditingController emailController = TextEditingController();

  // Instancia de FirebaseAuth para gestionar la autenticación de Firebase.
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          // Acción cuando el usuario hace clic en "¿Olvidaste tu contraseña?".
          onTap: () {
            _showForgotPasswordDialog(context);
          },
          child: const Text(
            "¿Olvidaste tu contraseña?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff259AC5),
            ),
          ),
        ),
      ),
    );
  }

  // Función para mostrar un diálogo donde ingresar el correo electrónico.
  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      const Text(
                        "Olvidaste tu contraseña",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        // Cerrar el dialogo
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    // Campo de texto donde ingresar correo electrónico.
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Ingresa tu correo electrónico",
                    ),
                    keyboardType: TextInputType
                        .emailAddress, // Teclado para correos electrónicos
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff259AC5)),
                    onPressed: () async {
                      // Enviar el enlace de restablecimiento de contraseña a la dirección de correo electrónico proporcionada.
                      await auth
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        // Muestra un mensaje de éxito al usuario.
                        // ignore: use_build_context_synchronously
                        showCustomSnackBar(context,
                            "Te hemos enviado el enlace para restablecer la contraseña a tu correo electrónico. Por favor, revisa tu bandeja de entrada.");
                      }).onError((error, stackTrace) {
                        // Muestra un mensaje de error si ocurre algún problema.
                        // ignore: use_build_context_synchronously
                        showCustomSnackBar(context, error.toString());
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // Cierra el diálogo.
                      emailController.clear(); // Limpia el campo de texto.
                    },
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
