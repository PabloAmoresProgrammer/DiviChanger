import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // Método para iniciar sesión con Google.
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // Método para cerrar sesión tanto en Google como en Firebase.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Método para eliminar la cuenta actual.
  Future<void> deleteAccount() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Elimina la cuenta de Firebase.
        await user.delete();
        // Cierra sesión en Google en caso de que el usuario se haya autenticado con Google.
        await _googleSignIn.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Se requiere reautenticación para eliminar la cuenta.
        // Aquí podrías redirigir al usuario a una pantalla de reautenticación o mostrar un mensaje.
        // ignore: avoid_print
        print("La eliminación de la cuenta requiere reautenticación.");
      } else {
        // ignore: avoid_print
        print(e.toString());
      }
    }
  }
}
