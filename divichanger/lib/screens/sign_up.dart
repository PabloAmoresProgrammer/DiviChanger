import 'screens.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controlador para el campo de texto del nombre.
  final TextEditingController nameController = TextEditingController();

  // Controlador para el campo de texto del correo electrónico.
  final TextEditingController emailController = TextEditingController();

  // Controlador para el campo de texto de la contraseña.
  final TextEditingController passwordController = TextEditingController();

  // Estado que indica si se está procesando una acción.
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    // Liberar recursos de los controladores cuando no se usen más.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // Método para registrar un nuevo usuario.
  void signupUser() async {
    setState(() {
      isLoading = true; // Mostrar indicador de carga.
    });

    // Llamada al servicio de registro con los datos ingresados.
    String res = await AuthService().registerUser(
        email: emailController.text,
        password: passwordController.text,
        username: nameController.text);

    if (res == "éxito") {
      setState(() {
        isLoading = false; // Ocultar indicador de carga
      });
      // Navegar al home si el registro es exitoso
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false; // Ocultar indicador de carga
      });
      // Mostrar mensaje de error en caso de fallo
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Altura de la pantalla
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // Evitar redimensionar al mostrar teclado
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.8,
              child: Image.asset('assets/images/logo.png'),
            ),
            // Campo de texto para ingresar el nombre
            CustomTextField(
                icon: Icons.person,
                inputController: nameController,
                placeholderText: 'Ingresa tu nombre',
                inputType: TextInputType.text),
            // Campo de texto para ingresar el correo electrónico
            CustomTextField(
                icon: Icons.email,
                inputController: emailController,
                placeholderText: 'Ingresa tu correo electrónico',
                inputType: TextInputType.emailAddress),
            // Campo de texto para ingresar la contraseña
            CustomTextField(
              icon: Icons.lock,
              inputController: passwordController,
              placeholderText: 'Ingresa tu contraseña',
              inputType: TextInputType.text,
              isPasswordField: true,
            ),
            // Botón para registrar al usuario
            CustomButton(
                onButtonPressed: signupUser, buttonText: "Registrarse"),
            const SizedBox(height: 50),
            // Enlace para redirigir al login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Ya tienes una cuenta?"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    " Iniciar sesión",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
