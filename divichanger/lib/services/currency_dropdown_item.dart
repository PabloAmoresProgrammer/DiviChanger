import 'package:flutter/material.dart';

/// Widget para representar un elemento de la lista desplegable de monedas,
/// permitiendo marcar o desmarcar una moneda como favorita.
class CurrencyDropdownItem extends StatelessWidget {
  final String nombreMonedaSeleccionada;
  final bool esMonedaFavorita;
  final Future<void> Function() alAlternarFavorito;

  const CurrencyDropdownItem({
    super.key,
    required this.nombreMonedaSeleccionada,
    required this.esMonedaFavorita,
    required this.alAlternarFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, actualizarEstado) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                nombreMonedaSeleccionada,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                esMonedaFavorita ? Icons.star : Icons.star_border,
                color: esMonedaFavorita ? Colors.yellow : Colors.grey,
              ),
              onPressed: () async {
                await alAlternarFavorito();
                actualizarEstado(() {}); // Refresca el estado del ícono
              },
            ),
          ],
        );
      },
    );
  }
}
