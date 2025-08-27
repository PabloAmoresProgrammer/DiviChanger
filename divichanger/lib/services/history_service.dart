import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final FirebaseFirestore firestore;

  HistoryService({required this.firestore});

  /// Retorna un stream del historial del usuario, ordenado por fecha descendente.
  Stream<QuerySnapshot> getHistoryStream(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Borra todo el historial del usuario.
  Future<void> deleteAllHistory(String userId) async {
    final querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Borra un elemento del historial dado su [docId].
  Future<void> deleteHistoryItem(String userId, String docId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .doc(docId)
        .delete();
  }
}
