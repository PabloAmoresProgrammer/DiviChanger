import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import '../routes/app_routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario actualmente autenticado.
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff259AC5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Parte superior: icono de información alineado a la derecha.
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.info, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.creditsScreen);
                      },
                    ),
                  ),
                  // Parte inferior: foto de perfil y correo electrónico.
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Foto de perfil.
                      if (user != null && user.photoURL != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                          radius: 40,
                        )
                      else
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child:
                              Icon(Icons.person, size: 65, color: Colors.black),
                        ),
                      const SizedBox(height: 10),
                      // Correo electrónico.
                      Text(
                        user?.email ?? 'Sin correo',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Opción para ir a Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.homeScreen);
              },
            ),
            // Opción para ir al Historial
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.historyScreen);
              },
            ),
            // Opción para Cerrar Sesión
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Cierre de sesión'),
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Color(0xff259AC5)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (confirm == true) {
                  await FirebaseAuthService().signOut();
                  // Navega al login usando la ruta nombrada.
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  );
                }
              },
            ),
            // Opción para eliminar la cuenta
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'ELIMINAR CUENTA',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Confirmar eliminación'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción es irreversible.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Color(0xff259AC5)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await FirebaseAuthService().deleteAccount();
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
