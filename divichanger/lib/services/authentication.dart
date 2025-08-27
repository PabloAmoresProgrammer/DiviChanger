import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instancia de FirebaseFirestore para interactuar con Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instancia de FirebaseAuth para interactuar con la autenticación de Firebase.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter para obtener el UID del usuario actual.
  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // Función para registrar un nuevo usuario en la base de datos.
  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String result = "Ocurrió un error";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Guarda los detalles del usuario en Firestore.
        await _firestore.collection("users").doc(credentials.user!.uid).set({
          'username': username,
          'uid': credentials.user!.uid,
          'email': email,
        });
        result = "éxito";
      }
    } catch (error) {
      return error.toString();
    }
    return result;
  }

  // Función para autenticar a un usuario existente.
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = "Ocurrió un error";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        result = "éxito";
      } else {
        result = "Por favor ingresa todos los campos";
      }
    } catch (error) {
      return error.toString();
    }
    return result;
  }

  // Función para cerrar sesión.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
