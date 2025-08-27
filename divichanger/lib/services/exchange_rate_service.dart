import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  // URL base de la API para obtener los tipos de cambio.
  final String _baseApiUrl = 'https://api.exchangerate-api.com/v4/latest/';

  /// Obtiene los datos de tipos de cambio para la moneda base indicada.
  Future<Map<String, dynamic>> fetchRates(String monedaBase) async {
    final response = await http.get(Uri.parse('$_baseApiUrl$monedaBase'));
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON y la retorna.
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los tipos de cambio');
    }
  }
}
