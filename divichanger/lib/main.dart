import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:divichanger/screens/screens.dart';
import 'package:divichanger/routes/app_routes.dart'; // Asegúrate de importar tus rutas

Future<void> main() async {
  // Comprueba que los widgets estén inicializados antes de ejecutar la app.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase.
  await Firebase.initializeApp();

  // Inicia la app.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Elimina el banner de debug.
      debugShowCheckedModeBanner: false,

      // Define el mapa de rutas nombradas.
      routes: AppRoutes.routes,

      // Utiliza el StreamBuilder para decidir cuál pantalla mostrar de forma dinámica.
      home: StreamBuilder(
        // Escucha cambios en el estado de autenticación de Firebase.
        stream: FirebaseAuth.instance.authStateChanges(),

        // Construye la interfaz basada en los datos de autenticación.
        builder: (context, authSnapshot) {
          // Si el usuario está autenticado, muestra la pantalla principal.
          if (authSnapshot.hasData) {
            return const HomeScreen();
          }
          // Si no está autenticado, muestra la pantalla de inicio de sesión.
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
