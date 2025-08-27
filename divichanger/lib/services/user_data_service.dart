import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divichanger/screens/screens.dart';

class UserDataService {
  final FirebaseFirestore firestore;

  UserDataService({required this.firestore});

  /// Carga la lista de monedas favoritas del usuario.
  /// Si no hay un usuario autenticado, no hace nada y devuelve una lista vacía.
  Future<List<String>> loadFavorites() async {
    String? userId = FirebaseAuthService().currentUserId;
    if (userId == null) {
      return []; // No hace nada, solo retorna una lista vacía.
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('favorites')) {
        return List<String>.from(userData['favorites']);
      } else {
        await firestore.collection('users').doc(userId).set({
          'favorites': [],
        }, SetOptions(merge: true));
        return [];
      }
    } else {
      await firestore.collection('users').doc(userId).set({
        'favorites': [],
      }, SetOptions(merge: true));
      return [];
    }
  }

  /// Alterna el estado "favorito" de una moneda para el usuario.
  /// Si no hay un usuario autenticado, no hace nada.
  Future<void> toggleFavorite(
      String currency, List<String> currentFavorites) async {
    String? userId = FirebaseAuthService().currentUserId;
    if (userId == null) {
      return; // No hace nada, solo retorna.
    }

    List<String> updatedFavorites = List.from(currentFavorites);
    if (currentFavorites.contains(currency)) {
      updatedFavorites.remove(currency);
    } else {
      updatedFavorites.add(currency);
    }
    await firestore
        .collection('users')
        .doc(userId)
        .set({'favorites': updatedFavorites}, SetOptions(merge: true));
  }

  Future<void> updateFavorites(List<String> favorites) async {
    String? userId = FirebaseAuthService().currentUserId;
    if (userId == null) {
      return;
    }
    await firestore
        .collection('users')
        .doc(userId)
        .set({'favorites': favorites}, SetOptions(merge: true));
  }

  /// Registra en Firestore la conversión realizada.
  /// Si no hay un usuario autenticado, no hace nada.
  Future<void> logConversion({
    required String sourceCurrency,
    required String targetCurrency,
    required double amount,
    required double convertedAmount,
    required double exchangeRate,
  }) async {
    String? userId = FirebaseAuthService().currentUserId;
    if (userId == null) {
      return; // No hace nada, solo retorna.
    }
    await firestore.collection('users').doc(userId).collection('history').add({
      'sourceCurrency': sourceCurrency,
      'targetCurrency': targetCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'exchangeRate': exchangeRate,
      'timestamp': Timestamp.now(),
    });
  }
}
