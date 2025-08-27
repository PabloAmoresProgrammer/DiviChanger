import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ID del usuario autenticado.
    String? idUsuario = FirebaseAuthService().currentUserId;

    // Si no hay usuario autenticado, muestra un mensaje informándolo.
    if (idUsuario == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("HISTORIAL"),
          backgroundColor: const Color(0xff259AC5),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text("No hay usuario autenticado")),
      );
    }

    final HistoryService servicioHistorial =
        HistoryService(firestore: FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(
        title: const Text("HISTORIAL"),
        backgroundColor: const Color(0xff259AC5),
        foregroundColor: Colors.white,
        actions: [
          // Botón para borrar todo el historial.
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Mostrar diálogo de confirmación para borrar todo el historial.
              bool confirmarEliminacion = await showConfirmationDialog(
                context,
                "Borrar Historial",
                "¿Estás seguro de que quieres borrar todo el historial?",
              );
              if (confirmarEliminacion) {
                await servicioHistorial.deleteAllHistory(idUsuario);
              }
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: Colors.white,
      // StreamBuilder para escuchar los cambios en el historial en tiempo real.
      body: StreamBuilder<QuerySnapshot>(
        stream: servicioHistorial.getHistoryStream(idUsuario),
        builder: (context, snapshot) {
          // Mostrar un indicador de carga mientras se obtiene la información.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si no hay datos o el historial está vacío.
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay historial disponible."));
          }

          // Construir la lista de historial.
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var itemHistorial = snapshot.data!.docs[index];
              // Convertir el campo 'timestamp' a tipo DateTime.
              final fechaHora =
                  (itemHistorial['timestamp'] as Timestamp).toDate();

              return ListTile(
                title: Text(
                  "${itemHistorial['sourceCurrency']} → ${itemHistorial['targetCurrency']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Cantidad: ${itemHistorial['amount']} → ${itemHistorial['convertedAmount']}\n"
                  "Tasa: ${itemHistorial['exchangeRate']}",
                ),
                trailing: Text(
                  // Mostrar la fecha y hora sin los milisegundos.
                  fechaHora.toString().split('.')[0],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                // Permite eliminar un elemento individual mediante una pulsación prolongada.
                onLongPress: () async {
                  bool confirmarEliminacion = await showConfirmationDialog(
                    context,
                    "Eliminar Conversión",
                    "¿Quieres eliminar esta conversión?",
                  );
                  if (confirmarEliminacion) {
                    await servicioHistorial.deleteHistoryItem(
                        idUsuario, itemHistorial.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
